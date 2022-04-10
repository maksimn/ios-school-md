# HTTP protocol.

### Метрики взаимодействия

Latency - время добора пакета от клиента до сервера

Propagation + Transmission + Processing + Queuing

основная задержка


Bandwidth - макс. пропускная способность канала


При малых объемах данных основной эффект на производительность дает latency. Веб-разработчик должен бороться за уменьшение latency.

1) Дорогая операция -- это установка соединения. (3-хшаговое рукопожатие).

2) В начале соединения передача данных по сети идёт не самым эффективным образом (медленный старт).

Что делать?

Уменьшить объем передаваемых данных

Уменьшить число соединений TCP

При POST-запросе имя хоста находится в заголовке Host.

Кэш

Инвалидация

Http-заголовок ответа сервера содержит 

`Last-modified` 
дата и время последней модификации ресурса

После этого клиент отправляет запрос с заголовком

`If-Modified-Since:` 

со значением из `Last-modified.`

При генерации ответа сервер сравнивает эти 2 значения. При равенстве ответ:

```
HTTP/1.1 304 Not Modified
```

Более современный HTTP/1.1 механизм инвалидации построен не на датах, а на хешах. ответ сервера, заголовок

`ETag: g1g3c5c54...`

У клиента при повторном получении ресурса
заголовок

`If-None-Match: g1g3c5c54...`

---

Дополнительные коды

`401` unauth
`403` forbidden
`405` method not allowed например, PUT а не POST

`500` internal server error