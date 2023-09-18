import face_recognition
import os, sys
import cv2
import numpy as np
import math
import pymongo
from flask import Flask,request,jsonify,Blueprint
import threading
import queue
from keras.utils import to_categorical
from keras.preprocessing.image import load_img
from keras.models import Sequential
from keras.layers import Dense, Conv2D, Dropout, Flatten, MaxPooling2D
import pandas as pd
from keras.models import model_from_json


app = Flask(__name__)
client = pymongo.MongoClient('mongodb://localhost:27017/')
db = client['classroom'] 
collection = db['students']
students = {}




def face_confidence(face_distance, face_match_threshold=0.6):
    range = (1.0 - face_match_threshold)
    linear_val = (1.0-face_distance)/(range*2.0)

    if face_distance > face_match_threshold:
        return str(round(linear_val * 100, 2)) + '%'
    else:
        value = (linear_val + ((1.0 - linear_val) * math.pow((linear_val - 0.5) * 2, 0.2))) * 100
        return str(round(value, 2)) + '%'
    

class faceRecognition:
    face_locations = []
    face_encodings = []
    face_names = []
    known_face_encodings = []
    known_face_names = []
    temp_students_present = []
    process_current_frame = True
    video_capture = cv2.VideoCapture(0)

    def __init__(self) -> None:
        self.encode_faces()

    json_file = open("facialemotionmodel.json", "r")
    # json_file = open("fer.json", "r")

    model_json = json_file.read()
    json_file.close()
    model = model_from_json(model_json)

    model.load_weights("facialemotionmodel.h5")
    # model.load_weights("fer.h5")
    haar_file=cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
    face_cascade=cv2.CascadeClassifier(haar_file)

    def extract_features(self, image):
        feature = np.array(image)
        feature = feature.reshape(1,48,48,1)
        return feature/255.0


    def encode_faces(self):
        for image in os.listdir('assets'):
            face_image = face_recognition.load_image_file(f'assets/{image}')
            face_encoding = face_recognition.face_encodings(face_image)[0]

            self.known_face_encodings.append(face_encoding)
            self.known_face_names.append(image)
            name = image.split(".")[0]
            students[f'{name}'] = {'presence':'absent', 'wasPresent':False, 'timeGone':0, 'Warning': False, 'emotion':'neutral'}
        # print(self.known_face_names)

    def run_recognition(self):
        
        if not self.video_capture.isOpened():
            sys.exit('Video source not found')

        count = 0
        
        labels = {0 : 'angry', 1 : 'disgust', 2 : 'fear', 3 : 'happy', 4 : 'neutral', 5 : 'sad', 6 : 'surprise'}

        while True:

            ret, frame = self.video_capture.read()
            #print("shafty", ret)
            
            if(self.process_current_frame):
                small_frame = cv2.resize(frame, (0,0), fx=0.25, fy=0.25)
                rgb_small_frame = small_frame[:, :, ::-1]

                self.face_locations = face_recognition.face_locations(rgb_small_frame)
                self.face_encodings = face_recognition.face_encodings(rgb_small_frame, self.face_locations)

                self.temp_students_present = []
                self.face_names = []
                for face_encoding in self.face_encodings:
                    matches = face_recognition.compare_faces(self.known_face_encodings, face_encoding)
                    name = 'Unknown'
                    confidence = 'Unknown'

                    face_distances = face_recognition.face_distance(self.known_face_encodings, face_encoding)
                    best_match_index = np.argmin(face_distances)

                    if matches[best_match_index]:
                        # print(matches[best_match_index])
                        #print(students_present.keys())
                        name = self.known_face_names[best_match_index]
                        #print(name)
                        confidence = face_confidence(face_distances[best_match_index])

                    self.face_names.append(f'{name.split(".")[0]} ({confidence})')
                    if(name != 'Unknown'):
                        self.temp_students_present.append(f'{name.split(".")[0]}')
                #print(self.temp_students_present)
            count+=1
            print(count)
            if count % 30 == 0:
                for student in students:
                    if student in self.temp_students_present:
                        students[f'{student}']['presence'] = 'present'
                        students[f'{student}']['timeGone'] = 0
                        students[f'{student}']['wasPresent'] = True
                        students[f'{student}']['timeGone'] = 0
                    else:
                        students[f'{student}']['presence'] = 'absent'
                        students[f'{student}']['emotion'] = 'neutral'
                        if students[f'{student}']['wasPresent']:
                            students[f'{student}']['timeGone'] += 1
                        if students[f'{student}']['timeGone'] >= 900:
                            students[f'{student}']['Warning'] = True
                    print(student)
                    
                print(students)

            self.process_current_frame = not self.process_current_frame
            gray=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
            for(top, right, bottom, left), name in zip(self.face_locations, self.face_names):
                top *=4
                right *=4
                bottom *=4
                left *=4

                cv2.rectangle(frame, (left, top), (right, bottom), (0,0,255), 2)
                cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0,0,255), -1)
                cv2.putText(frame, name, (left+6, bottom-6), cv2.FONT_HERSHEY_DUPLEX, 0.8, (255, 255, 255), 1)
                image = gray[top:bottom, left:right]
                # cv2.rectangle(frame,(p,q),(p+r,q+s),(255,0,0),2)
                cv2.rectangle(frame, (left, top), (right, bottom), (255, 0, 0), 2)
                image = cv2.resize(image,(48,48))
                img = self.extract_features(image)
                pred = self.model.predict(img)
                prediction_label = labels[pred.argmax()]
                # print("Predicted Output:", prediction_label)
                # cv2.putText(im,prediction_label)
                cv2.putText(frame, '% s' %(prediction_label), (left-10, top-10),cv2.FONT_HERSHEY_COMPLEX_SMALL,2, (0,0,255))
                # print(students[name.split(" ")[0]])
                # print(prediction_label)
                if(name.split(" ")[0] != 'Unknown'):
                    students[name.split(" ")[0]]['emotion'] = prediction_label
                

                
            cv2.imshow("FaceRecognition", frame)



            if cv2.waitKey(1) == ord('q'):
                break

        self.video_capture.release()
        cv2.destroyAllWindows


def run_cv():
    fr = faceRecognition()
    fr.run_recognition()

# def run_flask():
#     app.run(host='0.0.0.0', port=2526)




#JUST TO TEST

@app.route('/get_students', methods=['POST'])
def get_students():

        try:
            return jsonify(students), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404


#####

if __name__ == "__main__":
    flask_thread = threading.Thread(target=lambda: app.run(host='0.0.0.0', port=2526))
    # cv_thread = threading.Thread(target=run_cv)

    flask_thread.daemon = True
    # cv_thread.daemon = True

    flask_thread.start()
    run_cv()





