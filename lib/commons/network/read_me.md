
Sự kết hợp với @JsonSerializable()
   Thư viện json_serializable tạo ra các hàm _$PostFromJson(json). Để tận dụng Tear-offs, bạn chỉ cần khai báo một "proxy" nhỏ trong model để làm cầu nối.

@JsonSerializable()
class Post {
final int id;
final String title;

Post({required this.id, required this.title});

// Đây là hàm do build_runner tạo ra
factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

// Tear-off helper: Bạn định nghĩa thêm cái này để dùng .mapToWrapped
static Post fromJson(dynamic json) => Post.fromJson(json as Map<String, dynamic>);

static List<Post> fromJsonList(dynamic json) =>
(json as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
}


// --- TẠI REPOSITORY ---

void fetchEverything() async {
// 1. Lấy dữ liệu từ API dùng chuẩn dự án mình
final (user, err1) = await client.request("profile").mapToNetworkResponse(User.fromMap);

// 2. Lấy dữ liệu từ API đối tác (YourResponse)
final (items, err2) = await client.request("partner/items").mapToYourResponse(Item.fromJsonList);

// 3. Lấy dữ liệu từ API cũ/đơn giản (JSON Trần)
final (posts, err3) = await client.request("raw-posts").mapToObject(Post.fromJsonList);

// Xử lý logic rất tập trung:
if (user != null) {
print("Chào ${user.fullName}");
} else if (err1 != null) {
print("Lỗi: ${err1.message}");
}
}

// --- TRONG MODEL (Để dùng Tear-offs) ---
class Post {
// ... properties ...
static Post fromJson(dynamic json) => Post.fromMap(json as Map<String, dynamic>);
static List<Post> fromJsonList(dynamic json) => (json as List).map((e) => Post.fromJson(e)).toList();
}