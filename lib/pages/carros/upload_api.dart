import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:carros/utils/http_helper.dart' as http;
import 'package:carros/pages/api_response.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class UploadService {
  static Future<ApiResponse<String>> upload(File file) async {

    try {
      String url = "https://carros-springboot.herokuapp.com/api/v2/upload";

      List<int> imageBytes = file.readAsBytesSync(); //le a imagens como array de bytes
      String base64Image = convert.base64Encode(imageBytes); //realiza o base64Encode/converte o array de bytes da figura para uma String

      String fileName = path.basename(file.path); //nome do arquivo

      var headers = {"Content-Type": "application/json"};

      var params = {
            "fileName": fileName,
            "mimeType": "image/jpeg",
            "base64": base64Image
          };

      String json = convert.jsonEncode(params); //tem que converter o map para json

      print("http.upload: " + url);
      print("params: " + json);

      final response = await http
          .post(
            url,
            body: json
          )
              .timeout(
            Duration(seconds: 30),
            onTimeout: _onTimeOut,
          );

      print("http.upload << " + response.body);

      Map<String, dynamic> map = convert.json.decode(response.body); //converte a resposta json em map

      String urlFoto = map["url"]; //le url já convertida para map

      return ApiResponse.ok(urlFoto);//retorna a url da foto do carro como resposta por isso tipou como string Future<ApiResponse<String>>
    } catch (error, exception) {
      print("Erro ao fazer o upload $error - $exception");
      return ApiResponse.error("Não foi possível fazer o upload");
    }
  }

  static FutureOr<Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }
}