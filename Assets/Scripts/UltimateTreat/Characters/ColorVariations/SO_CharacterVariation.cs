using UnityEngine;

[CreateAssetMenu(fileName = "Character color variation", menuName = "Create Scriptable Objects/Color variation")]
public class SO_CharacterVariation : ScriptableObject
{
    //[SerializeField] private CharacterType _CharacterModel; 
    [SerializeField] private Color _colorOption;

    //public CharacterType CharacterModel => _CharacterModel;
    public Color ColorOption => _colorOption;
}
