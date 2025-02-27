function Sensor_health(info_level, teamSensorStatus, stockSensorStatus) {
        if (info_level == 0) {
            return null;
          }
          return SensorStatusComponent(info_level, teamSensorStatus),
          SensorStatusComponent(info_level, stockSensorStatusSensorStatus);
  }

  function Sensor_health(info_level, teamSensorStatus, stockSensorStatus) {
    if (info_level == 0) {
        return null;
      }
      return SensorStatusComponent(info_level, teamSensorStatus),
      SensorStatusComponent(info_level, stockSensorStatusSensorStatus);
  }
  
  
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<Sensor_health />);
//   **SensorHealthComponent (Container for rendering Sensor Health)**

//   State:
  
//   - int8 info_level
//   - sensorStatusMsg[] teamSensorStatus
//   - sensorStatusMsg[] stockSensorStatus
  
//   Render:
  
//   **→ SensorStatusComponent []** teamSensorHealth
  
//   → SensorStatusComponents [] stockSensorHealth
  
//   if info_level is 0, don’t render the SensorStatusComponent
  
//   **SensorStatusComponent**
  
//   State: 
  
//   - sensorStatusMsg
//   - int8 info_level
  
//   Render:
  
//   - If info_level is 0
//       - Return sensor name + green/yellow/red depending on the status field in the SensorStatus.msg
//   - If info_level is 1
//       - Return List with each sensor field’s information


  