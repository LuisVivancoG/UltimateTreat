using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerDisplay : MonoBehaviour
{
    [SerializeField] private Image _displayedSprite;
    [SerializeField] private Button _rightButton;
    [SerializeField] private Button _leftButton;
    [SerializeField] private List<Sprite> _characterPictures;

    public Image DisplayedSprite { get { return _displayedSprite; } set { _displayedSprite = value; } }
    public Button RightBtn { get { return _rightButton; } set { _rightButton = value; } }
    public Button LeftBtn { get { return _leftButton; } set { _leftButton = value; } }


    public void NewDisplay()
    {
        _displayedSprite.sprite = PickRandomImage();
    }
    private Sprite PickRandomImage()
    {
        int lenght = _characterPictures.Count;
        var i = Random.Range(0, lenght);
        var randomImage = _characterPictures[i];

        return randomImage;
    }
}
