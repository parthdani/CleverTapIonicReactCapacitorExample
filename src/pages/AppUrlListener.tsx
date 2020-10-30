import React, { useEffect } from 'react';
import { Plugins } from '@capacitor/core';
const { App: CapApp } = Plugins;

const AppUrlListener: React.FC<any> = () => {
  useEffect(() => {
    CapApp.addListener('appUrlOpen', (data: any) => {
      
      alert(data.url);
      
    });
  }, []);

  return null;
};

export default AppUrlListener;