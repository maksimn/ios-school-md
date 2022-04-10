## Введение в redux-saga

__Сага__ - это функция-генератор, внутри которой производятся сайд-эффекты (запросы, обращения к кэшу и т.д.). Этот генератор делает yield объектов в сага-миддлвару. Эти объекты являются инструкциями миддлвару. 

```js
import axios from 'axios';

export const loadPhotoData = () => {
    return axios.get('https://jsonplaceholder.typicode.com/photos')
        .then(response => (response.data));
};
```

```javascript
export function* loadPhotos() {
    try {
        const photos = yield call(loadPhotoData);
        yield put(photoActionCreators.loadPhotosSuccess(photos));
    } catch {
        yield put(photoActionCreators.loadPhotosError());
    }
}

export function* watchLoadPhotos(): any {
    yield takeEvery(LOAD_PHOTOS_DATA, loadPhotos);
}
```

`put` - _ЭФФЕКТ_, который отдает инструкцию сделать dispatch данного действия. Эффект - это простой объект, который содержит инструкции, которые должны быть выполнены миддлварой. Когда миддлвара извлекает эффект, предоставленный сагой, она приостанавливает эту сагу до тех пор, пока эффект не выполнится. `call` - это тоже эффект.

`takeEvery` - хелпер, прослушивает все действия `LOAD_PHOTOS_DATA`, и вызывает для них сагу `loadPhotos`.

