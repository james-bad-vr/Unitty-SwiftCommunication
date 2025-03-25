
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;

public class PluginHelper : MonoBehaviour
{
    [SerializeField] private Text textResult;

    [DllImport("__Internal")]
    private static extern int _addTwoNumberInVisionOS(int a, int b);

    void Start()
    {
        AddTwoNumber();
    }

    public void AddTwoNumber()
    {
        int result = _addTwoNumberInVisionOS(10, 5);
        textResult.text = "10 + 5  is : " + result;
    }
}
