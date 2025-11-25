using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class PlayerUITracker : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI _playerTag;
    [SerializeField] private Image _playerPicture;
    [SerializeField] private GameObject[] _pointsDisplayed;
    [SerializeField] private List<Sprite> _pictures;
    private Dictionary<int, GameObject> _starsDictionary = new Dictionary<int, GameObject> ();

    private Sprite PickRandomImage()
    {
        int lenght = _pictures.Count;
        var i = Random.Range (0, lenght);
        var randomImage = _pictures[i];

        return randomImage;
    }

    public void SetPlayerData(string playerID, Color currentColor)
    {
        var picture = PickRandomImage();

        _playerTag.text = playerID;
        this.gameObject.name = playerID;
        
        _playerPicture.sprite = picture;
        _playerPicture.color = currentColor;
        _playerTag.color = currentColor;

        SetDictionary();
    }

    void SetDictionary()
    {
        int i = 1;

        foreach(var point in _pointsDisplayed)
        {
            _starsDictionary.Add(i, point);
            //point.SetActive(false);
            i++;
        }
    }

    public void GrantStar(int currentScore)
    {
        if (_starsDictionary.ContainsKey(currentScore))
        {
            var star = _starsDictionary[currentScore];
            star.SetActive(true);
            if (_starsDictionary[currentScore].gameObject == true)
            {
                Debug.Log("Star is enable");
                _starsDictionary[currentScore].TryGetComponent<SquashAndStretch>(out var squash);
                squash.CheckForAndStartCoroutine();
            }
        }
        else Debug.Log($"{currentScore} is out of dictionary boundaries. Current size of dictionary is {_starsDictionary.Count}");
    }
}
