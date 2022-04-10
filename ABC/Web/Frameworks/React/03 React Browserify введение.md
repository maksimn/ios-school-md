Сначала установка

```
npm i --save browserify reactify vinyl-source-stream
```

reactify - пакет для компиляции JSX.

все эти пакеты риквайрятся в gulpfile.

```js
var browserify = require('browserify'); // Bundles JS
var reactify = require('reactify');  // Transforms React JSX to JS
var source = require('vinyl-source-stream'); // Use conventional text streams with Gulp
```

1) Задача для сборки .js-файлов

```js
gulp.task('js', function() {
    browserify(config.paths.mainJs)
        .transform(reactify)
        .bundle()
        .on('error', console.error.bind(console))
        .pipe(source('bundle.js')) // Задание имени сборки
        .pipe(gulp.dest(config.paths.dist + '/scripts')) // Место назначения для сборки
        .pipe(connect.reload()); // Перезагрузить браузер
});
```

