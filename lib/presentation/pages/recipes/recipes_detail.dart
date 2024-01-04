import 'package:flutter/material.dart';

class RecipesDetail extends StatefulWidget {
  final String recipeName;
  //final String imageUrl;
  final String time;
  final String people;
  final String ingredient;

  const RecipesDetail(
      {Key? key,
      required this.recipeName,
//   required this.imageUrl,
      required this.people,
      required this.time,
      required this.ingredient})
      : super(key: key);

  @override
  State<RecipesDetail> createState() => _RecipesDetailState();
}

class _RecipesDetailState extends State<RecipesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1.0),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Foto que ocupa todo el ancho y 1/4 de la altura
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/pizza-carbonara.jpg'), // Reemplaza con la ruta de tu imagen
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 30, // Puedes ajustar la posición según tus necesidades
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                  color: Colors
                      .black, // Puedes ajustar el color del ícono según tus necesidades
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // Contenedor con borde circular arriba y que ocupa el espacio restante
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.60,
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(232, 232, 232,
                      1.0), // Puedes ajustar el color según tus necesidades
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        30.0), // Ajusta el radio según tus necesidades
                    topRight: Radius.circular(
                        30.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // El contenido debajo de la imagen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.recipeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 110, 8, 211),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.favorite,
                          size: 40,
                          color: Color.fromARGB(255, 110, 8, 211),
                        )
                      ],
                    ),
                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.timer,
                            color: Color.fromRGBO(0, 0, 0, 0.667)),
                        SizedBox(width: 4),
                        Text(
                          "${widget.time} min",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(0, 0, 0, 0.667)),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.person,
                            color: Color.fromRGBO(0, 0, 0, 0.667)),
                        SizedBox(width: 4),
                        Text(
                          "${widget.people} comensales",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(0, 0, 0, 0.667)),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Text(
                      'Ingredientes',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 110, 8, 211)),
                    ),
                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.ingredient,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Puedes agregar más widgets según tus necesidades
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
