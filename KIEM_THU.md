# Kết quả kiểm thử trước khi bàn giao

Ngày kiểm tra: 14/11/2026. Môi trường: Java 21, Maven 3.9.9, Hibernate 6.6.59.Final, H2 2.3.232 và Tomcat nhúng 11.0.29.

Lệnh: `mvn clean verify` (cùng build lifecycle với `./mvnw clean verify`).

**Kết quả: BUILD SUCCESS — 13 test, 0 failure, 0 error, 0 skipped.**

| Nhóm | Số test | Nội dung |
| --- | ---: | --- |
| `JpaIntegrationTest` | 8 | CRUD đọc lại qua EntityManager khác; tìm kiếm, phân trang, count; tên trùng; ký tự % và _; tên rỗng/trạng thái; rollback; quan hệ Category–Video và chặn xóa dữ liệu liên quan; ID không tồn tại |
| `WebIntegrationTest` | 5 | Servlet/JSP và tiếng Việt; tải/đọc/giữ/thay/xóa ảnh; lỗi input, trùng tên, file giả/quá lớn; CSRF, ID sai, cấm GET xóa, đường dẫn ảnh; escape HTML, tìm kiếm và phân trang |

Các HTTP test khởi động Tomcat thực, biên dịch JSP và gửi yêu cầu HTTP tới ứng dụng. Database test là H2 in-memory ở MySQL mode; không cần database hay mật khẩu cá nhân.

WAR đã đóng gói ở `dist/jpa-category.war`; có đầy đủ thư viện runtime. H2, Tomcat nhúng và các lớp test không có trong WAR. Source chính ở `src`, cấu hình Maven ở `pom.xml` và `.mvn`.

**Giới hạn kiểm chứng:** chưa kết nối MySQL trên máy sinh viên hoặc upload repository GitHub. Trước khi nộp, cấu hình MySQL theo README, chạy `JpaSmokeTest`, thử lại CRUD trên MySQL, điền họ tên/MSSV/lớp và push source lên GitHub. Không dùng kết quả H2 để khẳng định đã test trên MySQL.
