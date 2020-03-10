from __future__ import print_function
import firebase_admin
from firebase_admin import credentials
import datetime

from firebase_admin import messaging


cred = credentials.Certificate("thasflutter-firebase-adminsdk-9vt7z-a6b866890f.json")
firebase_admin.initialize_app(cred)


registration_token = 'f5ebJycL0F4:APA91bG1tV2e32k1C6KVY8gBHGdKhpnxo22npVntLBaHJ8SxZODn_suVK182PS_Oma6j6M7Z4FdNmUtD1SkFRzScdZlDW3be_2ZnsUBNlsvSBZ5m4u4LIVsdq0yFPJD1uJwN9uA0XPB_'

message = messaging.Message(
    data={
        'msg': 'Bora acai',
    },

    token=registration_token,
)



response = messaging.send(message)
print('Successfully sent message:', response)