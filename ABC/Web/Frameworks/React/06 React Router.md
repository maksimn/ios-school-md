## react-router

* Отображает вложенные представления на вложенные маршруты

* Декларативен

`Route` - компонент, определяющий маршруты. 1 страница - 1 маршрут.

`DefaultRoute` - для URL типа "/".

`NotFoundRoute` - client 404 page.

`Redirect` - перенаправление на другой маршрут.

Параметры URL (`/course/:id`) и параметры запроса автоматически встраиваются как props во вложенный компонент маршрута.

### Переходы между маршрутами

`willTransitionTo` - определяет, должен ли быть совершен переход на эту страницу (напр., авторизован ли пользователь).

`willTransitionFrom` - запускает проверки перед тем, как пользователь покинет страницу.

```js
var Settings = React.createClass({
  statics: {
    willTransitionTo: function (transition, params, query, callback) {
      if (!isLoggedIn) {
        transition.abort();
        callback();
      }
    }
  }
});
```

### Hash vs History url

Hash Location

`yoursite#/sth`

* некрасиво
* работает во всех браузерах
* не работает с серверным рендером

History Location

`yoursite/sth`

* чистые URL
* IE10+
* поддерживает серверный рендер

### Router Mixins

```js
var Page = React.createClass({
    mixins: [Router.Navigation, Router.State]
});
```

С помощью этого можно осуществлять навигацию из разных мест.

```
this.transitionTo('routeName')
```