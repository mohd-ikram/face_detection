import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppLocale extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "home": "Home",
          "search": "Search",
          "profile": "Profile",
          "cart": "Cart",
          "wishlist": "Wishlist",
          "my_order": "My Order",
          "check_your_order": "Check your order",
          "address": "Address",
          "my_address": "My Address",
          "settings": "Settings",
          "manage_settings": "Manage Settings",
          "tc": "T&C",
          "term_condition": "Term and Condition",
          "faq": "FAQ",
          "logout": "Logout",
          "exit": "Exit from application",
        },
        'fr_FR': {
          "home": "Accueil",
          "search": "Recherche",
          "profile": "Mon compte",
          "cart": "Panier",
          "wishlist": "Liste d'envie",
          "my_order": "Ma commande",
          "check_your_order": "Vérifier la commande",
          "my_address": "Mon adresse",
          "settings": "Paramètres",
          "manage_settings": "Gérer les paramètres",
          "tc": "T&C",
          "term_condition": "Conditions générales",
          "faq": "FAQ",
          "logout": "Déconnexion",
          "exit": "Quitter l'application",
        }
      };
}
