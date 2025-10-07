using UnityEngine;

[CreateAssetMenu(fileName = "Character color picker", menuName = "Create Scriptable Objects/Color picker")]

public class AllColorsPicker : ScriptableObject
{
    [SerializeField] private SO_CharacterVariation[] _colorsAvailable; 
    public SO_CharacterVariation[] ColorsAvailable => _colorsAvailable;
}
