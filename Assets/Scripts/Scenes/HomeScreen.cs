using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class HomeScreen : MonoBehaviour
{
    [SerializeField] private TMP_Text _uiPlayersCount;
    [SerializeField] private string _sceneLevel;
    [SerializeField] private PlayerInput _playerInput;
    [SerializeField] private Animator _explosionAnim;
    //private bool _inputPressed;
    private bool _canUpdatePlayers = true;

    private int _numberPlayers;

    private void Start()
    {
        _numberPlayers = 2;
        _uiPlayersCount.text =  _numberPlayers.ToString() + " > ";
        //StartCoroutine(StartGame());
    }

    //IEnumerator StartGame()
    //{
    //    StartCoroutine(Landing());
    //    yield return null;
    //    //StartCoroutine(SelectPlayers());
    //}

    //IEnumerator Landing()
    //{
    //    Debug.Log("Starting landing loop");
    //    while (!_inputPressed)
    //    {
    //        new WaitForSeconds(2f);
    //        yield return null;
    //    }
    //    _canUpdatePlayers = true;
    //}

    //IEnumerator SelectPlayers()
    //{
    //    Debug.Log("Starting select players loop");
    //    //while (!_inputPressed)
    //    //{
    //        yield return null;
    //    _explosionAnim.SetBool("isPlayin?", true);
    //    //}
    //}

    public void OnChanginPlayers(InputAction.CallbackContext value)
    {
        if (!_canUpdatePlayers)
            return;

        Vector2 inputMovement = value.ReadValue<Vector2>();
        if (inputMovement.x > 0)
        {
            _numberPlayers++;
            _numberPlayers = Mathf.Clamp(_numberPlayers, 2, 10);
            UpdateUI();
            StartCoroutine(ChangePlayersCooldown());
        }
        else if (inputMovement.x < 0)
        {
            _numberPlayers--;
            _numberPlayers = Mathf.Clamp(_numberPlayers, 2, 10);
            UpdateUI() ;
            StartCoroutine(ChangePlayersCooldown());
        }
    }

    void UpdateUI()
    {
        if (_numberPlayers > 9)
        {
            _uiPlayersCount.text = " < ";
        }
        if (_numberPlayers <3)
        {
            _uiPlayersCount.text = _numberPlayers.ToString() + " > ";
        }
        else
        {
            _uiPlayersCount.text = " < " + _numberPlayers.ToString() + " > ";
        }
    }

    private IEnumerator ChangePlayersCooldown()
    {
        _canUpdatePlayers = false;
        yield return new WaitForSeconds(.2f);
        _canUpdatePlayers = true;
    }


    public void GameplayScene(InputAction.CallbackContext value)
    {
        //Debug.Log("Transitioning");
        StartCoroutine(Transition());
        _uiPlayersCount.text = _numberPlayers.ToString();
    }

    IEnumerator Transition()
    {
        int request = _numberPlayers;
        PlayerPrefs.SetInt("RequestedPlayers", request); // Save int
        PlayerPrefs.Save(); // Save to disk
        _explosionAnim.SetBool("isPlayin?", true);
        yield return new WaitForSeconds(2.5f);
        SceneManager.LoadScene(_sceneLevel);
    }
}
