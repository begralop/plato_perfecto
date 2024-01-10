import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/presentation/pages/favoriterecipe/favorite_recipe_page.dart';
import 'package:plato_perfecto/presentation/pages/home/home_page.dart';
import 'package:plato_perfecto/presentation/pages/home/home_page_navbar.dart';
import 'package:plato_perfecto/presentation/pages/login/login_page.dart';
import 'package:plato_perfecto/presentation/pages/profile/profile.dart';
import 'package:plato_perfecto/presentation/pages/recipes/recipes_page.dart';
import 'package:plato_perfecto/presentation/pages/recipes/recipes_detail_page.dart';
import 'package:plato_perfecto/presentation/pages/register/register_screen.dart';
import 'package:plato_perfecto/presentation/pages/splash/splash_screen.dart';

class NavigationRoutes {
  static const INITIAL_ROUTE = "/";

  static const LOGIN_ROUTE = "/login";
  static const REGISTER_ROUTE = "/register";

  static const HOME_ROUTE = "/home";
  static const RECIPES_LIST_ROUTE = "/recipes";
  static const FAVOURITE_ROUTE = "/favorite";
  static const PROFILE_ROUTE = "/profile";

  static const DETAIL_RECIPE_ROUTE =
      "$RECIPES_LIST_ROUTE/$_DETAIL_RECIPE_ROUTE";
  static const DETAIL_FAVORITE_ROUTE =
      "$FAVOURITE_ROUTE/$_DETAIL_FAVORITE_ROUTE";
  static const DETAIL_HOME_ROUTE =
      "$HOME_ROUTE/$_DETAIL_HOME_ROUTE";
  static const _DETAIL_RECIPE_ROUTE = "detail";
  static const _DETAIL_FAVORITE_ROUTE = "detail";
  static const _DETAIL_HOME_ROUTE = "detail";
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
            routes: [
              GoRoute(
                path: NavigationRoutes._DETAIL_HOME_ROUTE,
                builder: (context, state) {
                  final Map<String, dynamic> params =
                      state.extra as Map<String, dynamic>;

                  return RecipesDetail(
                    recipeName: params['name'] ?? '',
                    image: params['image'] ?? NetworkImage(''),
                    people: params['people'] ?? '',
                    time: params['time'] ?? '',
                    ingredients: params['ingredients'] ?? ['1', '2'],
                  );
                },
              )
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.RECIPES_LIST_ROUTE,
            builder: (context, state) => RecipesPage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._DETAIL_RECIPE_ROUTE,
                builder: (context, state) {
                  final Map<String, dynamic> params =
                      state.extra as Map<String, dynamic>;

                  return RecipesDetail(
                    recipeName: params['name'] ?? '',
                    image: params['image'] ?? NetworkImage(''),
                    people: params['people'] ?? '',
                    time: params['time'] ?? '',
                    ingredients: params['ingredients'] ?? ['1', '2'],
                  );
                },
              )
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.FAVOURITE_ROUTE,
            builder: (context, state) => FavoriteRecipePage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._DETAIL_FAVORITE_ROUTE,
                builder: (context, state) {
                  final Map<String, dynamic> params =
                      state.extra as Map<String, dynamic>;

                  return RecipesDetail(
                    recipeName: params['name'] ?? '',
                    image:
                        params['image'] ?? "assets/images/pizza-carbonara.jpg",
                    people: params['people'] ?? '',
                    time: params['time'] ?? '',
                    ingredients: params['ingredients'] ?? ['1', '2'],
                  );
                },
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
