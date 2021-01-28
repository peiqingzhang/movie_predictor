import os  
import pandas as pd 
import torch
from tqdm import tqdm
from transformers import BertTokenizer, BertForSequenceClassification
from torch.utils.data import TensorDataset,DataLoader, RandomSampler, SequentialSampler
import numpy as np
from flask import Flask
from flask_restful import Api, Resource, reqparse
APP = Flask(__name__)
API = Api(APP)

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')



tokenizer = BertTokenizer.from_pretrained(
    'bert-base-uncased',
    do_lower_case = True
)

model = BertForSequenceClassification.from_pretrained(
    "bert-base-uncased",
    num_labels = 10, 
    output_attentions = False, 
    output_hidden_states = False 
)

model.load_state_dict(torch.load('./Models/BERT_ft_epoch7.model', map_location=torch.device('cpu')))

class Predict(Resource):
    @staticmethod
    def post():
        parser = reqparse.RequestParser()
        parser.add_argument('review')
        args = parser.parse_args()  
        X_new = list(args.values())
        review_text = X_new[0]
        encoded_review = tokenizer.encode_plus(
        review_text,
        add_special_tokens=True,
        return_token_type_ids=False,
        padding = 'max_length',
        truncation=True,
        return_attention_mask=True,
        return_tensors='pt'
        )

        input_ids = encoded_review['input_ids'].to(device)
        attention_mask = encoded_review['attention_mask'].to(device)
        output = model(input_ids, attention_mask)

        res = torch.argmax(output[0],dim= 1).numpy()
        out = {'Predicted score': int(res[0] + 1)}
      
        return out, 200


API.add_resource(Predict, '/predict')

if __name__ == '__main__':
    from waitress import serve
    serve(APP, host="0.0.0.0", port=1080)
                     

