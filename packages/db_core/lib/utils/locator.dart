/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 18/4/26 - 14:11
 * To change this template use File | Settings | File Templates.
 */

enum _ServiceType { singleton, factory, lazySingleton }

class _ServiceFactory<T> {
    final T Function() builder;
    final _ServiceType type;
    T? instance;

    _ServiceFactory(this.builder, this.type);
}

// --- QUẢN LÝ VÒNG ĐỜI ---
// Tu xoa cac du lieu lien quan trong object truoc khi reset
abstract class DbLocatorDisposable {
    void dispose();
}

class DbLocator {
    static final DbLocator _instance = DbLocator._internal();
    static DbLocator get instance => _instance;
    DbLocator._internal();

    final Map<Type, _ServiceFactory<dynamic>> _factories = {};
    bool allowReassignment = false;

    // Logic đăng ký tập trung
    void _register<T>(_ServiceFactory<T> factory) {
        if (isRegistered<T>() && !allowReassignment) {
            throw Exception("Service ${T.toString()} đã tồn tại. Bật 'allowReassignment' để ghi đè.");
        }
        _factories[T] = factory;
    }

    // Check if a service is already registered
    bool isRegistered<T>() => _factories.containsKey(T);

    // Đăng ký Singleton: Khởi tạo ngay
    void registerSingleton<T>(T service) => _register<T>(_ServiceFactory<T>(() => service, _ServiceType.singleton)..instance = service);

    // Đăng ký Lazy Singleton: Khởi tạo khi dùng lần đầu
    void registerLazySingleton<T>(T Function() builder) => _register<T>(_ServiceFactory<T>(builder, _ServiceType.lazySingleton));

    // Đăng ký Factory: Tạo mới mỗi lần gọi
    void registerFactory<T>(T Function() builder) => _register<T>(_ServiceFactory<T>(builder, _ServiceType.factory));

    // --- QUẢN LÝ VÒNG ĐỜI ---

    // Reset 1 instance cụ thể (thường dùng khi Logout)
    void resetLazySingleton<T>() {
        final factory = _factories[T];
        if (factory != null && factory.type == _ServiceType.lazySingleton) {
            _disposeInstance(factory.instance);
            factory.instance = null;
        }
    }

    // Reset toàn bộ app (Dùng khi chuyển User/Logout)
    void resetAll() {
        for (var f in _factories.values) {
            if (f.type == _ServiceType.lazySingleton) {
                _disposeInstance(f.instance);
                f.instance = null;
            }
        }
    }

    // Gỡ bỏ hoàn toàn (Unregister)
    void unregister<T>() {
        final factory = _factories.remove(T);
        if (factory != null) _disposeInstance(factory.instance);
    }

    void _disposeInstance(dynamic instance) {
        if (instance is DbLocatorDisposable) {
            instance.dispose();
        }
    }

    // --- TRUY XUẤT ---
    T get<T>() {
        final factory = _factories[T];
        if (factory == null) throw Exception("Service ${T.toString()} chưa được đăng ký!");

        switch (factory.type) {
            case _ServiceType.factory: return factory.builder() as T;
            case _ServiceType.lazySingleton:
                factory.instance ??= factory.builder();
                return factory.instance as T;
            case _ServiceType.singleton: return factory.instance as T;
        }
    }

    T call<T>() => get<T>();
}

final locator = DbLocator.instance;

/* Read me guideline

Bước 1: Khởi tạo trong main.dart

void setupDependency() {
  // 1. Đăng ký Config môi trường
  // locator.registerSingleton<[interface class]]>(object class());
  locator.registerSingleton<AppConfig>(ProdConfig());

  // 2. Đăng ký Dio (Lazy)
  locator.registerLazySingleton<Dio>(() {
    final config = locator<AppConfig>();
    final dio = Dio(BaseOptions(baseUrl: config.baseUrl));

    // Thêm các Interceptor đã tách class
    dio.interceptors.addAll([
      TokenInterceptor(dio),
      ErrorInterceptor(),
    ]);
    return dio;
  });

  // 3. Đăng ký NetworkClient (Common Library của bạn)
  locator.registerLazySingleton<NetworkClient>(() => NetworkClient(locator<Dio>()));
}

void main() {
  setupDependency();
  runApp(const MyApp());
}

Ví dụ Demo: Sự lan tỏa phụ thuộc

1. Định nghĩa các Class có sự phụ thuộc lẫn nhau

class Database {
  Database() { print("--- 📦 Database initialized"); }
}

class UserStorage {
  final Database db;
  UserStorage(this.db) { print("--- 💾 UserStorage initialized using Database"); }
}

class AuthService {
  final UserStorage storage;
  AuthService(this.storage) { print("--- 🔑 AuthService initialized using UserStorage"); }
}

2. Đăng ký vào MyLocator (Thiết lập "Dây chuyền")

void setupDependencies() {
  // Đăng ký Database
  locator.registerLazySingleton<Database>(() => Database());

  // Đăng ký UserStorage: Nó tự "hỏi" locator để lấy Database
  locator.registerLazySingleton<UserStorage>(() => UserStorage(locator<Database>()));

  // Đăng ký AuthService: Nó tự "hỏi" locator để lấy UserStorage
  locator.registerLazySingleton<AuthService>(() => AuthService(locator<UserStorage>()));
}

3. Sức mạnh của sự lan tỏa (The Magic)

void main() {
  setupDependencies();

  print("🚀 Bắt đầu lấy AuthService...");

  // Chỉ gọi 1 cái, nhưng Locator sẽ tự kích hoạt chuỗi dây chuyền:
  // 1. Tạo Database -> 2. Tạo UserStorage -> 3. Tạo AuthService
  final auth = locator<AuthService>();

  print("✅ Đã có AuthService hoàn chỉnh!");
}


* */

