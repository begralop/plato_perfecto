// ignore_for_file: constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/presentation/pages/favorite/favorite.dart';
import 'package:plato_perfecto/presentation/pages/home/home_page.dart';
import 'package:plato_perfecto/presentation/pages/home/home_page_navbar.dart';
import 'package:plato_perfecto/presentation/pages/login/login_page.dart';
import 'package:plato_perfecto/presentation/pages/profile/profile.dart';
import 'package:plato_perfecto/presentation/pages/recipes/recipes.dart';
import 'package:plato_perfecto/presentation/pages/recipes/recipes_detail.dart';
import 'package:plato_perfecto/presentation/pages/register/register_screen.dart';
import 'package:plato_perfecto/presentation/pages/splash/splash_screen.dart';

class NavigationRoutes {
  // ignore: constant_identifier_names
  static const INITIAL_ROUTE = "/";

  static const LOGIN_ROUTE = "/login";
  static const REGISTER_ROUTE = "/register";

  static const HOME_ROUTE = "/home";
  static const RECIPES_LIST_ROUTE = "/recipes";
  static const FAVOURITE_ROUTE = "/favorite";
  static const PROFILE_ROUTE = "/profile";

  static const DETAIL_RECIPE_ROUTE =
      "$RECIPES_LIST_ROUTE/$_DETAIL_RECIPE_ROUTE";
  static const DETAIL_FAVORITE_ROUTE = "$FAVOURITE_ROUTE/$_DETAIL_FAVORITE_ROUTE";
//static const ADD_RECIPE_ROUTE = "$HOME_ROUTE/$_ADD_RECIPE_ROUTE";

  // static const _ADD_RECIPE_ROUTE = "fourth";
  static const _DETAIL_RECIPE_ROUTE = "detail";
    static const _DETAIL_FAVORITE_ROUTE = "detail";

}

final GoRouter router =
    GoRouter(initialLocation: NavigationRoutes.INITIAL_ROUTE, routes: [
  GoRoute(
    path: NavigationRoutes.INITIAL_ROUTE,
    builder: (context, state) => SplashScreen(),
  ),
  GoRoute(
    path: NavigationRoutes.LOGIN_ROUTE,
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: NavigationRoutes.REGISTER_ROUTE,
    builder: (context, state) => RegisterPage(),
  ),
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomePageNavbar(
            navigationShell: navigationShell,
          ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.HOME_ROUTE,
            builder: (context, state) => HomePage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.RECIPES_LIST_ROUTE,
            builder: (context, state) => RecipesPage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._DETAIL_RECIPE_ROUTE,
                builder: (context, state) => const RecipesDetail(),
              )
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.FAVOURITE_ROUTE,
            builder: (context, state) => FavoritePage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._DETAIL_FAVORITE_ROUTE,
                builder: (context, state) => const RecipesDetail(),
              )
            ],
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.PROFILE_ROUTE,
            builder: (context, state) => ProfilePage(),
          )
        ])
      ])
]);
