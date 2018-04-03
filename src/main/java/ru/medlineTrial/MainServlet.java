package ru.medlineTrial;

import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

@WebServlet(name = "MainServlet", urlPatterns = {"/getInfo"})

public class MainServlet extends HttpServlet {
    private static final String QUERY_GET_DATA = "select " +
                                                "  p.number " +
                                                ", p.name " +
                                                ", p.vendor " +
                                                ", o.qty " +
                                                ", o.ship_dt " +
                                                ", o.receive_dt " +
                                                "from orders o " +
                                                "join parts p on p.id = o.part_id " +
                                                "where p.number like ? " +
                                                "and p.name like ? " +
                                                "and p.vendor like ? " +
                                                "and o.qty >= ? " +
                                                "and (coalesce(o.ship_dt, '1900-01-01') >= to_date(?, 'yyyy-mm-dd') and coalesce(o.ship_dt, '1900-01-01') <= to_date(?, 'yyyy-mm-dd')) " +
                                                "and (coalesce(o.receive_dt, '1900-01-01') >= to_date(?, 'yyyy-mm-dd') and coalesce(o.receive_dt, '1900-01-01') <= to_date(?, 'yyyy-mm-dd'));";

    private static final String MAX_UB_DATE = "4000-01-01";
    private static final String MIN_LB_DATE = "1900-01-01";

    private Connection con;

    @Override
    public void init() {
        try {
            Class.forName("org.postgresql.Driver");
            con= DriverManager.getConnection("jdbc:postgresql://localhost:5432/goods","webapp", "hello");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(System.out);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        //1. parse input
        String number = request.getParameter("partNum");
        String name = request.getParameter("partName");
        String vendor = request.getParameter("vendor");

        String qtyStr = request.getParameter("qty");
        Integer qty = null;
        if (qtyStr != null && !qtyStr.isEmpty()) {
            qty = Integer.parseInt(qtyStr);
        } else {
            qty = 0;
        }

        String shpLb = request.getParameter("shipDtLb");
        String shpUb = request.getParameter("shipDtUb");
        String recLb = request.getParameter("recDtLb");
        String recUb = request.getParameter("recDtUb");

        if (shpLb == null || shpLb.isEmpty()) {
            shpLb = MIN_LB_DATE;
        }

        if (shpUb == null || shpUb.isEmpty()) {
            shpUb = MAX_UB_DATE;
        }

        if (recLb == null || recLb.isEmpty()) {
            recLb = MIN_LB_DATE;
        }

        if (recUb == null || recUb.isEmpty()) {
            recUb = MAX_UB_DATE;
        }

        //2. prepare query
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(QUERY_GET_DATA);
            ps.setString(1, "%" + number + "%");
            ps.setString(2, "%" + name + "%");
            ps.setString(3, "%" + vendor + "%");
            ps.setInt(4, qty);
            ps.setString(5, shpLb);
            ps.setString(6, shpUb);
            ps.setString(7, recLb);
            ps.setString(8, recUb);
        } catch (SQLException e) {
            e.printStackTrace();
            return;
        }

        //3. execute query
        ResultSet rs = null;
        try {
            rs = ps.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return;
        }

        //4. make List of orders
        ArrayList<Order> orders = new ArrayList<>();
        Order order;

        try {
            while (rs.next()){
                order = new Order();
                order.partNum = rs.getString(1);
                order.partName = rs.getString(2);
                order.vendor = rs.getString(3);
                order.qnty = rs.getInt(4);
                order.shipDt = rs.getDate(5);
                order.receiveDt = rs.getDate(6);

                orders.add(order);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        //5. convert List to json and return it
        String result = new Gson().toJson(orders);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(result);
    }
}