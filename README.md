Ứng dụng Java Web theo mô hình **Servlet/JSP → Service → DAO → JPA → MySQL**.
Triển khai từ hai tài liệu “CRUD category bằng JPA” và “Cấu hình và test JPA”.

Nguyễn Hữu Vinh-24110066

## 1. Nội dung đã thực hiện

| Yêu cầu | Vị trí / chức năng |
| --- | --- |
| Cấu hình JPA | `src/main/resources/META-INF/persistence.xml`, `JpaConfig.java` |
| Entity Category | ID tự tăng, tên, ảnh, trạng thái, `@NamedQuery` |
| Entity Video | `@ManyToOne` với Category; phía Category có `@OneToMany(mappedBy="category")` |
| DAO và interface | `ICategoryDao`, `CategoryDao`: persist, merge, remove, find, JPQL |
| Service và interface | `ICategoryService`, `CategoryServiceImpl`: kiểm tra tên, trạng thái, trùng tên |
| Controller | `CategoryController`, `ImageController` |
| View JSP/JSTL | Danh sách, thêm, sửa, xác nhận xóa |
| Hình ảnh | Link HTTP/HTTPS hoặc upload; xem ảnh, giữ ảnh cũ, thay ảnh, xóa ảnh |
| Tìm kiếm, phân trang | Theo tên, 5 dòng/trang, đếm tổng số kết quả |
| Test cấu hình JPA | `JpaSmokeTest`: persist Category + Video, đọc quan hệ, dọn dữ liệu |
| Test tự động | JUnit, cơ sở dữ liệu H2 + HTTP thực qua Tomcat nhúng |
| Đóng gói | WAR chạy Tomcat 11; workflow GitHub Actions |

Phạm vi là hai tài liệu đính kèm; **không có giao diện CRUD Video, đăng nhập hay đăng ký**, vì hai tài liệu chỉ dùng Video để minh họa quan hệ JPA. Nếu đề bài 01 riêng của lớp có thêm chức năng, cần đối chiếu và bổ sung trước khi nộp.

## 2. Công nghệ và khác biệt so với code mẫu

- JDK 21 (project biên dịch cho Java 21).
- Maven 3.9.9 qua `mvnw` / `mvnw.cmd`.
- Jakarta Servlet 6.1, JSP và JSTL 3; dùng namespace `jakarta.*`.
- Hibernate ORM 6.6.59.Final, Jakarta Persistence 3.1, Hibernate Validator 8.0.2.Final.
- MySQL 8.x; MySQL Connector/J 9.2.0.
- Tomcat 11; không dùng Tomcat 9 cho project Jakarta này.

Code mẫu trong tài liệu có một số tên chưa đồng nhất (`catename`/`categoryname`, `category`/`categories`), một số EntityManager chưa đóng và ví dụ trộn cấu hình SQL Server/MySQL. Project thống nhất **MySQL**, tên thuộc tính và khóa ngoại; dùng một EntityManagerFactory, đóng EntityManager sau mỗi thao tác, rollback khi lỗi và chỉ xóa ảnh cũ sau khi lưu DB thành công. Không sao chép mật khẩu từ tài liệu vào source.

Chọn bộ Hibernate 6.6 + JPA 3.1 tương thích để thực hành cùng API JPA trong tài liệu. Xem [tài liệu Hibernate](https://hibernate.org/orm/releases/6.6/) và [tài liệu Tomcat](https://tomcat.apache.org/migration-11.0.html).

## 3. Mở bằng VS Code

1. Giải nén vào ví dụ `D:\BaiTap\jpa-category`.
2. VS Code → **File → Open Folder** → chọn thư mục `jpa-category` có `pom.xml`.
3. Nên cài **Extension Pack for Java**. Chọn JDK 21 nếu VS Code hỏi.
4. **Terminal → New Terminal**, chọn PowerShell.
5. Kiểm tra Java:

```powershell
java -version
.\mvnw.cmd -v
```

Lần đầu Wrapper và Maven cần Internet để tải thư viện. Nếu báo `JAVA_HOME`, trỏ `JAVA_HOME` tới thư mục JDK thật trên máy (thư mục chứa `bin\java.exe` và `bin\javac.exe`), đóng và mở lại VS Code.

## 4. Xem giao diện nhanh khi chưa cấu hình MySQL

Từ terminal đang ở thư mục chứa `pom.xml`:

```powershell
.\mvnw.cmd test-compile exec:java "-Dexec.mainClass=vn.iotstar.dev.DevServer" "-Dexec.classpathScope=test" "-Dapp.db=h2"
```

Mở:

```text
http://localhost:8080/jpa-category/admin/categories
```

Chế độ này dùng Tomcat nhúng và H2 file `data/servletjpa`, dữ liệu được giữ qua lần chạy. Đây là chế độ xem thử; phần nộp/chứng minh MySQL dùng mục 5. Không cần cài Tomcat riêng khi dùng chế độ này. Nhấn **Ctrl+C** ở terminal để dừng.

Linux/macOS thay `.\mvnw.cmd` bằng `./mvnw`; chạy `chmod +x mvnw` một lần nếu cần.

## 5. Chạy với MySQL

### 5.1 Tạo database

Mở MySQL Workbench, kết nối máy chủ MySQL của bạn. Mở `database/01_create_database.sql` và Execute, hoặc chạy:

```sql
CREATE DATABASE IF NOT EXISTS servletjpa
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Hibernate sẽ tạo bảng `categories`, `videos`, unique constraint và khóa ngoại khi ứng dụng khởi động. Cấu hình `update` giữ dữ liệu hiện có; không đổi thành `create`/`create-drop` khi muốn giữ dữ liệu.

### 5.2 Cách A — chạy ngay từ terminal với Tomcat nhúng

Copy file mẫu cấu hình rồi sửa mật khẩu MySQL trong file mới:

```powershell
Copy-Item config\db.properties.example config\db.properties
```

Mở `config/db.properties` và sửa `db.user`, `db.password`, `db.url` theo máy bạn. File này được `.gitignore` bỏ qua.

Chạy:

```powershell
.\mvnw.cmd test-compile exec:java "-Dexec.mainClass=vn.iotstar.dev.DevServer" "-Dexec.classpathScope=test" "-Dapp.db=mysql"
```

Mở `http://localhost:8080/jpa-category/admin/categories`. Chỉ cần Workbench/máy chủ MySQL đang chạy; không mở Tomcat ngoài đồng thời trên cổng 8080.

### 5.3 Cách B — đóng gói WAR và chạy trên Tomcat đã cài

**Bước 1.** Build tại thư mục project:

```powershell
.\mvnw.cmd clean package
```

WAR ở `target/jpa-category.war`. Gói tải về cũng có sẵn bản đã build tại `dist/jpa-category.war`; có thể dùng bản này để deploy ngay với JDK 21 và Tomcat 11 sau khi cấu hình MySQL.

**Bước 2.** Trong thư mục `bin` của Tomcat, tạo `setenv.bat` theo `config/setenv.bat.example`.

- Sửa `JAVA_HOME` thành đường dẫn JDK chính xác của bạn (thường tên thư mục có đủ phiên bản).
- Sửa `DB_USER`, `DB_PASSWORD` thành thông tin MySQL thật.
- Có thể giữ `UPLOAD_DIR=D:\jpa-category-uploads`.
- File `setenv.bat` này nằm ở Tomcat, không đưa vào GitHub.
- Tomcat không tự đọc `config/db.properties` trong source. Nếu muốn dùng file đó với Tomcat ngoài, đặt đường dẫn tuyệt đối qua Java system property `db.config` trong `CATALINA_OPTS`.

Ví dụ nội dung `setenv.bat` sau khi sửa cho đúng máy:

```bat
@echo off
set "JAVA_HOME=C:\DUONG_DAN_JDK_21_CUA_BAN"
set "DB_USER=root"
set "DB_PASSWORD=MAT_KHAU_MYSQL_CUA_BAN"
set "UPLOAD_DIR=D:\jpa-category-uploads"
```

URL mặc định đã trỏ MySQL `localhost:3306/servletjpa`. Nếu dùng host/cổng khác, thêm `DB_URL` theo file mẫu.

**Bước 3.** Dừng Tomcat nếu đang chạy. Copy `target/jpa-category.war` vào `webapps` của Tomcat. Nếu deploy lại bản này, xóa WAR và thư mục `webapps/jpa-category` cũ trước khi copy bản mới; ảnh upload lưu ngoài thư mục deploy.

**Bước 4.** Trong terminal tại thư mục `bin` của Tomcat:

```powershell
.\catalina.bat run
```

**Bước 5.** Truy cập:

```text
http://localhost:8080/jpa-category/admin/categories
```

Nhấn **Ctrl+C** trong terminal Tomcat để dừng. Khi muốn thêm dữ liệu minh họa, chạy `database/02_sample_data.sql` **sau lần khởi động đầu tiên**.

### Thứ tự ưu tiên cấu hình

System properties (`-Ddb.password=...`) → biến môi trường (`DB_PASSWORD`) → file `config/db.properties` → mặc định trong persistence.xml. Không đưa mật khẩu thật vào persistence.xml. Thư mục ảnh mặc định là `jpa-category-uploads` trong home của người chạy Java; có thể đổi bằng `UPLOAD_DIR` hoặc `-Dupload.dir`.

## 6. Test JPA và kiểm tra bài

### Test tự động không cần MySQL

```powershell
.\mvnw.cmd clean verify
```

Test dùng H2 in-memory riêng, không dùng database MySQL hoặc dữ liệu demo của bạn. Các test thực hiện CRUD thật qua JPA, rollback khi lỗi, tìm kiếm, phân trang, kiểm tra Category–Video, biên dịch JSP qua Tomcat nhúng và gửi HTTP thêm/sửa/xóa/ảnh. Kết quả trong `target/surefire-reports`. H2 MySQL mode không thay thế kiểm tra trực tiếp trên MySQL.

### Test kết nối MySQL và quan hệ JPA theo tài liệu

Sau khi tạo và sửa `config/db.properties` ở mục 5.2:

```powershell
.\mvnw.cmd compile exec:java "-Dexec.mainClass=vn.iotstar.config.JpaSmokeTest"
```

Kết quả mong đợi: `JPA TEST OK` và `Đã dọn dữ liệu kiểm thử`. Chương trình thêm Category + Video trong một transaction, xóa persistence context, đọc lại quan hệ từ DB, rồi xóa dữ liệu test. Cần có MySQL đang chạy. ID tự tăng có thể bị nhảy số sau khi test; đây là hành vi bình thường.

### Kiểm tra bằng giao diện trước khi nộp

1. Thêm `Điện thoại`, trạng thái Hoạt động, không ảnh → xuất hiện trong danh sách.
2. Thêm `Laptop` kèm link ảnh hoặc upload PNG/JPG/GIF/WebP ≤ 2 MB.
3. Sửa tên, đổi sang Khóa; thử giữ ảnh cũ rồi thay ảnh khác.
4. Thêm tên rỗng/trùng hoặc file không phải ảnh → có thông báo lỗi.
5. Tạo trên 5 danh mục → xuất hiện phân trang; tìm tên → danh sách lọc đúng.
6. Xóa danh mục không chứa Video → dòng và ảnh upload tương ứng được xóa.
7. Chạy `JpaSmokeTest` bằng MySQL, kiểm tra log.
8. Trong Workbench: `USE servletjpa; SHOW TABLES; SELECT * FROM categories; SELECT * FROM videos;`.
9. Chụp màn hình danh sách, thêm, sửa và log test nếu giảng viên yêu cầu minh chứng. Chưa có ảnh chụp hay kết quả MySQL trên máy sinh viên trong gói này.

Danh mục chứa Video sẽ không xóa được cho đến khi chuyển hoặc xóa Video. Xóa dùng POST kèm CSRF; GET không thay đổi dữ liệu. Giao diện quản trị chưa có xác thực: dùng cho bài tập cục bộ.

## 7. Đưa lên GitHub và nộp UTExLMS

Xem [HUONG_DAN_GITHUB.md](HUONG_DAN_GITHUB.md) cho thao tác từng bước. Chỉ đưa source, không đưa ZIP thay cho source, không đưa `target`, `dist`, dữ liệu hay mật khẩu thật. Cập nhật họ tên/MSSV ở đầu README trước khi nộp.

## 8. Các file cần hiểu để trình bày

- `entity/Category.java`, `entity/Video.java`: ánh xạ object–table, ID và quan hệ hai chiều.
- `config/JpaConfig.java`: đọc cấu hình, tạo factory và cấp EntityManager.
- `dao/impl/CategoryDao.java`: persist/merge/remove/find, transaction và JPQL tham số.
- `service/impl/CategoryServiceImpl.java`: nghiệp vụ, kiểm tra dữ liệu.
- `controller/CategoryController.java`: nhận request, gọi service, forward JSP hoặc redirect.
- `web/ImageStorage.java`: lưu và dọn ảnh; `ImageController.java` trả dữ liệu ảnh.
- `WEB-INF/views/admin/`: danh sách, thêm, sửa; view nằm dưới WEB-INF để đi qua controller.
- `src/test/java/`: kiểm thử JPA và HTTP với H2/Tomcat nhúng.

## 9. Lỗi thường gặp

| Hiện tượng | Cách kiểm tra |
| --- | --- |
| `JAVA_HOME` / `javac` lỗi | Dùng JDK 21 đầy đủ, kiểm tra `.\mvnw.cmd -v` |
| `Access denied for user` | Kiểm tra user/password trong file riêng hoặc setenv.bat, khởi động lại tiến trình |
| `Unknown database servletjpa` | Chạy `01_create_database.sql` trước |
| `Communications link failure` | Kiểm tra MySQL service đang chạy, host/cổng DB đúng |
| Cổng 8080 bận | Dừng Tomcat/chương trình cũ; demo có thể thêm `"-Dhttp.port=8081"` |
| 404 | Đúng context `/jpa-category/admin/categories`; kiểm tra Tomcat đã deploy thành công |
| 500 / không start | Đọc terminal/log Tomcat từ lỗi đầu tiên; kiểm tra DB và JDK |
| 403 khi gửi form | Reload trang để lấy session/form mới rồi gửi lại |
| Upload bị từ chối | Dùng ảnh thật đúng định dạng ≤ 2 MB; tổng request ≤ 3 MB |
| Link ảnh không hiện | Kiểm tra URL ảnh trực tiếp và quyền cho phép nhúng của website nguồn |

## Tài liệu tham khảo

- Hai file hướng dẫn do giảng viên cung cấp.
- [Hibernate ORM 6.6](https://hibernate.org/orm/releases/6.6/).
- [Tomcat 11 Migration Guide](https://tomcat.apache.org/migration-11.0.html).
- [GitHub — Adding locally hosted code](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github?platform=windows).
