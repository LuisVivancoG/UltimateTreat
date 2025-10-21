using System.Collections;
using System.Collections.Generic;
using Unity.AI.Navigation;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameManager : Singleton<GameManager>
{
    [SerializeField] private GameObject _levelsM;

    [SerializeField] public List<PlayerController> _currentPlayers;
    [SerializeField] private CinemachineTargetGroup _targetGroup;

    [SerializeField] private CratesManager _spawnerManager;
    [SerializeField] private NavMeshSurface _levelSruface;

    [SerializeField] private float _initialHP;

    [SerializeField] private InputActionReference _actionReference;

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsM);
        }

#if UNITY_EDITOR
        _actionReference.action.started += context => OnExitEditMode(context);
        _actionReference.action.performed += context => OnExitEditMode(context);
#endif

        //_currentPlayers = new List<PlayerController>();
        //SetUpPlayers();
        StartCoroutine(Delay());
    }

    IEnumerator Delay()
    {
        yield return new WaitForSeconds(7f);
        _spawnerManager.SpawnCrates();
    }

    public void SetUpPlayers()
    {
        int tempID = 0;

        foreach (var player in _currentPlayers)
        {
            tempID++;

            player.SetUpPlayer(tempID, _initialHP);
            _targetGroup.AddMember(player.gameObject.transform, 1f, 1f);
            player.transform.position = _spawnerManager.GetLocationInBoundBox();
        }
        //SetPlayersHealth();
    }

#if UNITY_EDITOR
    public void OnExitEditMode(InputAction.CallbackContext value)
    {
        UnityEditor.EditorApplication.isPlaying = false;

    }
#endif
}
