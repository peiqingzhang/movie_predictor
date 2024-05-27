# Movie review rating predictor

hosted at: http://www.peiqing-zhang.info:999/ (no longer in use - commented by Peiqing on 27.05.2024)

- model_development.ipynb: traind a deep learning model with few thousands of reviews from IMDB. It predicts the rating the reviewer gave based on the content of the review, from 1 - 10. The test mean absolute error is 0.9.
- python_api: creates REST API for the model. It is hosted on an AWS EC2 instance, available at: http://13.48.45.7:1080/predict  (no longer in use - commented by Peiqing on 27.05.2024)

If you like to talk access it by Python, code in below gives an example.

```
import requests

url = 'http://13.48.45.7:1080/predict'  (no longer in use - commented by Peiqing on 27.05.2024)
body = {
    "review": "I loved this movie a lot!!!"
}
response = requests.post(url, data=body)
response.json()
```

- app.R: web application built with R shiny. It is hosted on an AWS EC2 instance with a public IP address which is assoicated with the domain name http://www.peiqing-zhang.info (no longer in use - commented by Peiqing on 27.05.2024) and talks with the deep learning model via API. In the web App, you can type (or copy and paste) the review to make the prediction, or upload the review as .txt file to make the prediction.
