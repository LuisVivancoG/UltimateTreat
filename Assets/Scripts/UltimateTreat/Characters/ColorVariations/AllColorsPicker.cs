using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Character color picker", menuName = "Create Scriptable Objects/Color picker")]

public class AllColorsPicker : ScriptableObject
{
    //[SerializeField] private GameObject _displayModel;
    [SerializeField] private SO_CharacterVariation[] _colorsAvailable; 
    //public SO_CharacterVariation[] ColorsAvailable => _colorsAvailable;
    //public GameObject DisplayModel => _displayModel;

    public Dictionary<int, Color> ColorsDictionary = new Dictionary<int, Color>();

    public void SetColorsDictionary()
    {
        int i = 0;
        foreach (var option in _colorsAvailable)
        {
            ColorsDictionary.Add(i, option.ColorOption);
            i++;
        }

    }
    public Color FetchColor(int requestedColor)
    {
        return ColorsDictionary[requestedColor];
    }
}
