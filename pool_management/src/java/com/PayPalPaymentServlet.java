package com; // Hoặc package bạn đang dùng cho servlet

import com.vnpay.common.Config; // Dùng chung Config
import dal.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Payments;
import models.Users;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;
import org.json.JSONObject; // Cần thêm thư viện JSON (ví dụ: org.json) vào project

@WebServlet(name = "paypalPayment", urlPatterns = {"/paypalPayment"})
public class PayPalPaymentServlet extends HttpServlet {
    private PaymentDAO paymentDao = new PaymentDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json"); // Trả về JSON cho frontend
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");
        if (action == null) {
            action = ""; // Mặc định là rỗng
        }
        try {
            switch (action) {
                case "createOrder":
                    handleCreateOrder(request, response, out);
                    break;
                case "captureOrder":
                    handleCaptureOrder(request, response, out);
                    break;
                default:
                    out.print("{\"error\": \"Invalid action\"}");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    break;
            }
        } catch (Exception e) {
            System.err.println("PayPal Payment Error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"error\": \"Internal Server Error: " + e.getMessage() + "\"}");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    private void handleCreateOrder(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws Exception {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"User not logged in\"}");
            return;
        }
        double total = Double.parseDouble(request.getParameter("total"));
        int packageId = Integer.parseInt(request.getParameter("packageId"));
        Payments payment = new Payments();
        payment.setUserID(user.getUserID());
        payment.setPackageID(packageId);
        payment.setPoolID(1); // Cố định PoolID
        payment.setPaymentMethod("PayPal");
        payment.setTotal(total);
        payment.setStatus("PENDING_PAYPAL"); // Trạng thái mới cho PayPal
        payment.setPaymentTime(new Date());
        int paymentId = paymentDao.insertPayment(payment);
        if (paymentId <= 0) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to create payment record\"}");
            return;
        }
        session.setAttribute("currentPaymentId", paymentId);
        session.setAttribute("currentPaymentTotal", total); // Lưu total để đảm bảo khớp
        String accessToken = getPayPalAccessToken();
        if (accessToken == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to get PayPal access token\"}");
            return;
        }
        URL url = new URL(Config.paypal_ApiBaseUrl + "/v2/checkout/orders");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setDoOutput(true);
        String orderPayload = String.format("{\n" +
                "  \"intent\": \"CAPTURE\",\n" +
                "  \"purchase_units\": [\n" +
                "    {\n" +
                "      \"amount\": {\n" +
                "        \"currency_code\": \"USD\",\n" + // PayPal thường dùng USD, cân nhắc chuyển đổi tiền tệ
                "        \"value\": \"%.2f\"\n" +
                "      }\n" +
                "    }\n" +
                "  ],\n" +
                "  \"application_context\": {\n" +
                "    \"return_url\": \"http://localhost:9999/QuangHuy/paypalReturn\",\n" + // URL trả về sau khi phê duyệt
                "    \"cancel_url\": \"http://localhost:9999/QuangHuy/paypalCancel\"\n" +  // URL khi hủy
                "  }\n" +
                "}", total); // Formatted to 2 decimal places
        conn.getOutputStream().write(orderPayload.getBytes(StandardCharsets.UTF_8));
        int responseCode = conn.getResponseCode();
        BufferedReader in;
        if (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_CREATED) {
            in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            in = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            System.err.println("PayPal Create Order Error Response: " + readResponse(in));
            throw new IOException("Failed to create PayPal order, Response Code: " + responseCode);
        }
        String responseString = readResponse(in);
        JSONObject jsonResponse = new JSONObject(responseString);
        String orderId = jsonResponse.getString("id");
        out.print("{\"orderID\": \"" + orderId + "\"}");
        response.setStatus(HttpServletResponse.SC_OK);
    }
    private void handleCaptureOrder(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws Exception {
        HttpSession session = request.getSession();
        Integer paymentId = (Integer) session.getAttribute("currentPaymentId");
        Double expectedTotal = (Double) session.getAttribute("currentPaymentTotal");
        if (paymentId == null || expectedTotal == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Session data for payment missing\"}");
            return;
        }
        String orderID = request.getParameter("orderID");
        if (orderID == null || orderID.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Missing PayPal Order ID\"}");
            return;
        }
        String accessToken = getPayPalAccessToken();
        if (accessToken == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to get PayPal access token\"}");
            return;
        }
        URL url = new URL(Config.paypal_ApiBaseUrl + "/v2/checkout/orders/" + orderID + "/capture");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setDoOutput(true);
        conn.getOutputStream().write("{}".getBytes()); // Gửi body trống
        int responseCode = conn.getResponseCode();
        BufferedReader in;
        if (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_CREATED) {
            in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            in = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String errorResponse = readResponse(in);
            System.err.println("PayPal Capture Order Error Response: " + errorResponse);
            throw new IOException("Failed to capture PayPal order, Response Code: " + responseCode + ", Error: " + errorResponse);
        }
        String responseString = readResponse(in);
        JSONObject jsonResponse = new JSONObject(responseString);
        String status = jsonResponse.getString("status");
        Payments payment = new Payments();
        payment.setPaymentID(paymentId);
        if ("COMPLETED".equals(status)) {
            JSONObject purchaseUnit = jsonResponse.getJSONArray("purchase_units").getJSONObject(0);
            double capturedAmount = purchaseUnit.getJSONObject("payments").getJSONArray("captures").getJSONObject(0).getJSONObject("amount").getDouble("value");
            if (capturedAmount == expectedTotal) {
                payment.setStatus("Completed");
                out.print("{\"status\": \"success\", \"message\": \"Payment captured successfully!\"}");
            } else {
                payment.setStatus("Failed"); // Số tiền không khớp
                out.print("{\"status\": \"error\", \"message\": \"Amount mismatch!\"}");
                System.err.println("Amount mismatch for PaymentID " + paymentId + ": Expected " + expectedTotal + ", Got " + capturedAmount);
            }
        } else {
            payment.setStatus("Failed");
            out.print("{\"status\": \"error\", \"message\": \"Payment not completed: " + status + "\"}");
        }
        paymentDao.updateStatusOnly(payment); 
        session.removeAttribute("currentPaymentId"); // Xóa khỏi session sau khi hoàn tất
        session.removeAttribute("currentPaymentTotal");
        response.setStatus(HttpServletResponse.SC_OK);
    }
    private String getPayPalAccessToken() throws IOException {
        String authString = Config.paypal_ClientId + ":" + Config.paypal_Secret;
        String encodedAuth = Base64.getEncoder().encodeToString(authString.getBytes(StandardCharsets.UTF_8));
        URL url = new URL(Config.paypal_ApiBaseUrl + "/v1/oauth2/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Accept-Language", "en_US");
        conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);
        conn.getOutputStream().write("grant_type=client_credentials".getBytes(StandardCharsets.UTF_8));
        int responseCode = conn.getResponseCode();
        BufferedReader in;
        if (responseCode == HttpURLConnection.HTTP_OK) {
            in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            in = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            System.err.println("PayPal Access Token Error Response: " + readResponse(in));
            return null;
        }
        String responseString = readResponse(in);
        JSONObject jsonResponse = new JSONObject(responseString);
        return jsonResponse.getString("access_token");
    }
    private String readResponse(BufferedReader in) throws IOException {
        StringBuilder response = new StringBuilder();
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
        return response.toString();
    }
}