# MOVIX

Es una aplicación móvil para visualizar los nuevos estrenos de peliculas y sus detalles

## TMDB

La aplicación consume los servicios API REST, por lo tanto tendrás que crear una cuenta en la siguiente liga y solicitar una APIKEY para que la aplicación funcione.

 - [TMDB] https://www.themoviedb.org/signup?language=es Proporciona los datos de peliculas y series que se consumiran por la aplicación móvil MOVIX

## Dependencias

- [SDWebImage](https://github.com/SDWebImage/SDWebImage): Simplifica el proceso de descarga de las imagenes para mantenerlas en cache.

- [Lottie](https://github.com/airbnb/lottie-ios): Se utiliza para las animaciones, en este caso es usado para el loader de carga al consumir los servicios API REST

## Pasos para iniciar el proyecto

- Clona este reposotorio
- En la terminal, deberás estar en la raiz del proyecto y ejecutar el siguiente comando

```

  pod install
  
```
- Abrir el archivo con la extensión .workspace 
- Renombrar el archivo Config-Example por Config
- Remplazar el texto 'your_api_token_here' por el TOKEN DE ACCESO que se encuentra en la siguiente ruta https://www.themoviedb.org/settings/api , una vez que ya hayas hecho el registro y solicitado del API 
- Ejecuta la aplicación
