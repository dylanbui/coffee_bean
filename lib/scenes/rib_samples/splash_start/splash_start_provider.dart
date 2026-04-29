// import 'package:simple_auth_1/api/user_api.dart';
// import 'package:simple_auth_1/commons/base_provider.dart';
// import 'package:simple_auth_1/utils/tuple.dart';
// import '../../constants.dart';

import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/state_management/lib_provider/base_provider.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_builder.dart';

//ignore: must_be_immutable
class SplashStartProvider extends BaseProvider<DbNoteRoutable> {

    SplashStartProvider(super.router);

  // SplashStartPage({super.key, super.router});
  // SplashStartProvider({super.router}) : super(router: router)) {
  //   // init state
  //   isLoading = true;
  // };


  Future<String> fetchSomething() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final _isHaveData = prefs.getString(Constants.sp_have_data) ?? "";

    //TODO Call API from server and do sth
    await Future.delayed(const Duration(seconds: 3));
    router.navigate(SplashPageCompleteRoute(message: "SplashStartProvider --- DONE"));

    return "SplashStartProvider --- DONE";



    // if (_isHaveData.isEmpty) {
    //   await prefs.setString(Constants.sp_have_data, "just login_scene.login");
    //   view.goToNextScreen(true);
    // } else {
    //   view.goToNextScreen(false);
    // }

  }

  // Day la mo hinh xu ly nut bam goi server
  // Future<LoginType> doLogin(String username, String password) async {
  //
  //   // Gia lap goi server
  //   return await UserApi().doLogin(username, password);
  //
  // }

  // Future<Recipe> fetchAndSetRecipes() async {
  //   const url = 'https://bakeology-alpha-stage.herokuapp.com/user/recipes';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return null;
  //     }
  //     final List<Recipe> loadedRecipes = [];
  //     extractedData["recipes"].forEach((recipeData) {
  //       loadedRecipes.add(
  //         Recipe(
  //             id: recipeData["_id"],
  //             title: recipeData["title"],
  //             duration: recipeData["duration"],
  //             imageUrl: recipeData["imageUrl"],
  //             affordability: recipeData["affordability"],
  //             isVegetarian: recipeData["isVegetarian"],
  //             steps: recipeData["steps"],
  //             categories: recipeData["categories"],
  //             chef: recipeData["chef"]["_id"],
  //             chefName: recipeData["chef"]["name"],
  //             chefImageUrl: recipeData["chef"]["profileImageUrl"],
  //             complexity: recipeData["complexity"],
  //             ingredients: recipeData["ingredients"]),
  //       );
  //     });
  //     _recipes = loadedRecipes;
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }


}