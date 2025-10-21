using UnityEngine;

[CreateAssetMenu(fileName = "Character color picker", menuName = "Create Scriptable Objects/Color picker")]

public class AllColorsPicker : ScriptableObject
{
    [SerializeField] private GameObject _displayModel;
    [SerializeField] private SO_CharacterVariation[] _colorsAvailable; 
    public SO_CharacterVariation[] ColorsAvailable => _colorsAvailable;
    public GameObject DisplayModel => _displayModel;
}
