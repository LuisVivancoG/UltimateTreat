using System.Collections.Generic;
using UnityEngine;

public class ColorPicker : MonoBehaviour
{
    [SerializeField] private SO_CharacterVariation[] _colorsList;
    private Dictionary<int, Color> _colors = new Dictionary<int, Color>();
    /*
    private void Start()
    {
        for(int i = 0;  i < _colorsList.Length; i++)
        {
            _colors.Add(i, _colorsList.);
        }
    }*/
}
