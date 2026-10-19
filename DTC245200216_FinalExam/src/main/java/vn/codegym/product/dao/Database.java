package vn.codegym.product.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public final class Database {
 private Database(){}
 public static Connection getConnection() throws SQLException {
  String url=get("DB_URL","jdbc:mysql://localhost:3306/product_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8");
  return DriverManager.getConnection(url,get("DB_USER","root"),get("DB_PASSWORD",""));
 }
 private static String get(String key,String fallback){
  String value=System.getenv(key);return value==null?fallback:value;
 }
}