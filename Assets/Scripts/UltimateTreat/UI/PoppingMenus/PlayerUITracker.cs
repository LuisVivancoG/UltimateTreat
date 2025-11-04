using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class PlayerUITracker : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI _playerTag;
    [SerializeField] private Image _playerPicture;
    [SerializeField] private GameObject[] _pointsDisplayed;
    private Dictionary<int, GameObject> _starsDictionary = new Dictionary<int, GameObject> ();

    public void SetPlayerData(string playerID/*, Color currentColor*/)
    {
        _playerTag.text = playerID;
        this.gameObject.name = playerID;
        
        /*_playerPicture.color = currentColor;
        _playerTag.color = currentColor;*/

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
            //star.TryGetComponent<SquashAndStretch>(out var squash);
            //squash.CheckForAndStartCoroutine();
        }
        else Debug.Log($"{currentScore} is out of dictionary boundaries. Current size of dictionary is {_starsDictionary.Count}");
    }
}
