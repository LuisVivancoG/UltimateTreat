using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem.UI;

public class MESManager : MonoBehaviour
{
    [SerializeField] private MultiplayerEventSystem _playerEventS;
    [SerializeField] private GameObject _displayPrefab;

    private MenuFlows _inputManager;

    private void Awake()
    {
        _inputManager = FindAnyObjectByType<MenuFlows>();
        if (_inputManager != null )
        {
            Debug.Log("Manager found");
        }
    }

    private void Start()
    {
        StartCoroutine(FirstSelectionDelay());
        Instantiate(_displayPrefab, _inputManager.DisplayGrp.transform);
    }

    public void UpdateCurrentSelection(GameObject current)
    {
        _playerEventS.SetSelectedGameObject(current);
    }

    IEnumerator FirstSelectionDelay()
    {
        yield return new WaitForSeconds(1);
        _playerEventS.SetSelectedGameObject(_inputManager.InitialSelection);
        _playerEventS.playerRoot = _inputManager.gameObject;
    }
}
