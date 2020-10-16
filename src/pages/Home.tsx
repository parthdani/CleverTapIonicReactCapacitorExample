import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar, IonImg, IonFab, IonFabButton, IonIcon } from '@ionic/react';
import { Plugins, CameraResultType } from '@capacitor/core';
import { CleverTap } from '@ionic-native/clevertap';
import React, { Component } from 'react';
const { Camera } = Plugins;

const INITIAL_STATE = {
  photo: '',
};
export class Home extends Component {
  state: any = {};
  props: any = {};
  constructor(props: any) {
    super(props);
    CleverTap.setDebugLevel(3);
    CleverTap.createNotificationChannel("123456789", "Test Channel", "A TEST channel", 5, true);
    CleverTap.registerforpush();
    this.state = { ...INITIAL_STATE };
  }
  async takePicture() {
          CleverTap.recordEventWithName("Ionic React Push Events");
          const image = await Camera.getPhoto({
          quality: 90,
          allowEditing: false,
          resultType: CameraResultType.Uri
              });
          var imageUrl = image.webPath;
          // Can be set to the src of an image now
              this.setState({
                  photo: imageUrl
              })
            }

  render() {
    const { photo } = this.state;
    return (
      <IonPage>
        <IonHeader>
          <IonToolbar>
            <IonTitle>Ionic Blank</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonContent className="ion-padding">
          <IonImg style={{ 'border': '1px solid black', 'minHeight': '100px' }} src={photo} ></IonImg>
          <IonFab color="primary" vertical="bottom" horizontal="center" slot="fixed">
            <IonFabButton color="primary" onClick={() => this.takePicture()}>
              <IonIcon name="add" />
            </IonFabButton>
          </IonFab>
        </IonContent>
      </IonPage >
    );
  };
}
export default Home;