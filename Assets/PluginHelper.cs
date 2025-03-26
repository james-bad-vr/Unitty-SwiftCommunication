using System.Runtime.InteropServices;
using UnityEngine;
using System;

public class PluginHelper : MonoBehaviour
{
    [DllImport("__Internal")]
    private static extern int _addTwoNumberInVisionOS(int a, int b);

    [DllImport("__Internal")]
    private static extern int _getConnectedDeviceCount();

    [DllImport("__Internal")]
    private static extern IntPtr _getDeviceName(int index);

    [DllImport("__Internal")]
    private static extern IntPtr _getDeviceUniqueID(int index);

    private float _checkDevicesTimer = 0f;
    private const float CHECK_DEVICE_INTERVAL = 2.0f;

    void Start()
    {
        AddTwoNumber();
        CheckForDevices();
    }

    void Update()
    {
        // Periodically check for devices
        _checkDevicesTimer += Time.deltaTime;
        if (_checkDevicesTimer >= CHECK_DEVICE_INTERVAL)
        {
            _checkDevicesTimer = 0f;
            CheckForDevices();
        }
    }

    public void AddTwoNumber()
    {
        int result = _addTwoNumberInVisionOS(10, 5);
        Debug.Log("10 + 5 is: " + result);
    }

    public void CheckForDevices()
    {
        int deviceCount = _getConnectedDeviceCount();

        Debug.Log("Connected UVC Devices: " + deviceCount);

        for (int i = 0; i < deviceCount; i++)
        {
            IntPtr namePtr = _getDeviceName(i);
            string deviceName = Marshal.PtrToStringAnsi(namePtr);

            IntPtr idPtr = _getDeviceUniqueID(i);
            string deviceID = Marshal.PtrToStringAnsi(idPtr);

            Debug.Log($"Device {i}: {deviceName} (ID: {deviceID})");
        }
    }
}