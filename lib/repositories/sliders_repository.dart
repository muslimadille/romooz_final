import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/notification_count.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/slider_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class SlidersRepository {
  Future<SliderResponse> getSliders() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/sliders");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );
    /*print(response.body.toString());
    print("sliders");*/
    return sliderResponseFromJson(response.body);
  }

  Future<NotifcationCountResponse> getNotificationCount() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-counts");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    //  print(response.body.toString());
    // print("getNotificationCount${response.s}");
    return notifcationCountResponseFromJson(response.body);
  }
}
