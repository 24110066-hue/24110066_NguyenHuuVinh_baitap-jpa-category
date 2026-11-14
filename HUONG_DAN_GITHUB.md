# Đưa bài CRUD Category JPA lên GitHub và nộp UTExLMS

Làm trong thư mục **jpa-category có pom.xml**, sau khi giải nén gói bài tập. Tên repository ví dụ `baitap01-jpa-category`; có thể thêm MSSV theo quy định lớp. Thay mọi placeholder bằng thông tin của bạn.

## Cách 1 — Dùng Git trong terminal VS Code

### 1. Chuẩn bị

1. Cài [Git for Windows](https://git-scm.com/downloads/win) nếu chưa có. Mở lại VS Code sau khi cài.
2. Mở folder `jpa-category` bằng VS Code và mở Terminal PowerShell.
3. Chạy `git --version` để kiểm tra Git.
4. Sửa họ tên, MSSV, lớp ở đầu README.md.
5. Chạy `.\mvnw.cmd clean verify`; nếu dùng MySQL, chạy thêm và chụp minh chứng theo README.

### 2. Tạo repository rỗng

1. Đăng nhập [GitHub](https://github.com).
2. Nhấn **+ → New repository**.
3. Repository name: `baitap01-jpa-category`.
4. Chọn **Public** nếu lớp cho phép, để giảng viên mở link xem source. Nếu lớp yêu cầu Private, cấp quyền truy cập cho giảng viên theo hướng dẫn lớp.
5. **Không bật Add README, không thêm .gitignore hoặc license** ở bước này vì source đã có README và .gitignore.
6. Nhấn **Create repository**.
7. Copy URL HTTPS của repository, ví dụ `https://github.com/TEN_TAI_KHOAN/baitap01-jpa-category.git`.

### 3. Tạo commit ở máy

Trong terminal của folder có pom.xml, chạy từng lệnh:

```powershell
git init
git config user.name "HO TEN CUA BAN"
git config user.email "EMAIL_GITHUB_CUA_BAN"
git add .
git status
```

Kiểm tra danh sách staged có `pom.xml`, `README.md`, `src`, `database`, `config/*.example`, `.mvn` và `mvnw.cmd`. **Không có** `target`, `dist`, `config/db.properties`, dữ liệu H2 hay mật khẩu MySQL thật. `.gitignore` đã thiết lập các mục đó.

Sau đó chạy:

```powershell
git commit -m "Bai tap 01: CRUD Category bang JPA"
git branch -M main
```

`git config` ở đây chỉ đặt tên/email cho commit của repository này, không phải thao tác đăng nhập.

### 4. Liên kết và push

Thay `TEN_TAI_KHOAN` bằng username GitHub thật:

```powershell
git remote add origin https://github.com/TEN_TAI_KHOAN/baitap01-jpa-category.git
git remote -v
git push -u origin main
```

Nếu Git yêu cầu đăng nhập, chọn **Sign in with your browser** và hoàn tất trong trình duyệt của bạn. Không nhập mật khẩu GitHub thông thường vào lời nhắc Git HTTPS. Nếu môi trường yêu cầu PAT, làm theo hướng dẫn xác thực của GitHub, không gửi token cho người khác hoặc chép vào source.

### 5. Kiểm tra trên GitHub

1. Reload trang repo. Phải thấy **các file source** và README hiển thị; không chỉ một file ZIP.
2. Mở `src/main/java/vn/iotstar/entity/Category.java` và `src/main/resources/META-INF/persistence.xml` để kiểm tra source thực sự đã có.
3. Mở tab **Actions**, xem workflow `Build and test JPA`. Nếu có quyền chạy Actions và workflow đã chạy, chờ xanh; nếu đỏ, mở log để sửa.
4. Với repo Public, mở link bằng cửa sổ ẩn danh để kiểm tra giảng viên có thể xem mà không xin quyền.

### 6. Nộp lên UTExLMS

1. Copy **link trang repository**, ví dụ:

```text
https://github.com/TEN_TAI_KHOAN/baitap01-jpa-category
```

2. Vào đúng bài tập trên UTExLMS → **Add submission / Thêm bài nộp**.
3. Dán link GitHub vào ô nội dung/link theo giao diện môn học.
4. **Save changes / Lưu thay đổi**, rồi **Submit assignment / Nộp bài** nếu LMS yêu cầu bước cuối.
5. Kiểm tra trạng thái đã nộp; không chỉ lưu bản nháp. Không nộp link localhost vì giảng viên không truy cập máy bạn được.

## Cách 2 — Upload qua trình duyệt nếu chưa dùng Git

Cách terminal ở trên thuận tiện hơn để đưa đúng `.gitignore` và `.mvn` lên GitHub. Nếu upload bằng web:

1. Tạo repository trên GitHub.
2. Chọn **uploading an existing file**, hoặc **Add file → Upload files**.
3. Kéo các file/thư mục source **bên trong `jpa-category`** vào vùng upload; `pom.xml` nên ở gốc repository.
4. Gồm: `src`, `database`, `config` (chỉ file `.example`), `README.md`, `HUONG_DAN_GITHUB.md`, `KIEM_THU.md`, `pom.xml`, `mvnw`, `mvnw.cmd`, `.gitignore`, `.mvn`, `.github`.
5. Windows có thể ẩn các mục bắt đầu bằng dấu chấm; bật hiển thị file ẩn hoặc dùng Git ở Cách 1. Đặc biệt cần `.mvn/wrapper/maven-wrapper.properties` để Wrapper hoạt động.
6. **Tự loại bỏ** `target`, `dist`, `data`, file mật khẩu `config/db.properties`. Upload bằng trình duyệt không tự áp dụng `.gitignore` như `git add`.
7. Nhập thông điệp commit rồi **Commit changes**.
8. Kiểm tra source đã hiện và nộp link repo như Cách 1.

Không upload chỉ file ZIP rồi nộp, vì giảng viên cần đọc source trên GitHub.

## Khi sửa bài sau lần push đầu

```powershell
git add .
git commit -m "Cap nhat bai tap JPA"
git push
```

## Một số lỗi Git

| Lỗi | Xử lý |
| --- | --- |
| `git is not recognized` | Cài Git, mở lại VS Code |
| `Author identity unknown` | Chạy hai lệnh `git config user.name` và `git config user.email` ở trên |
| `remote origin already exists` | Kiểm tra `git remote -v`; nếu URL sai, dùng `git remote set-url origin URL_DUNG` |
| `src refspec main does not match any` | Kiểm tra đã `git add .`, `git commit` và `git branch -M main` |
| `Repository not found` / 403 | Kiểm tra URL, đúng tài khoản đang đăng nhập và quyền ghi |
| Push bị reject vì repo đã có commit | Không force push; cách dễ nhất là clone repo đó ra folder khác, copy source vào (không copy .git), rồi add/commit/push |

Tham khảo: [hướng dẫn GitHub chính thức](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github?platform=windows).
