using UnityEngine;
using UnityEngine.EventSystems;

public class EndScreen : MonoBehaviour
{
    [Header("GameplayScene")]
    [SerializeField] private string _nextScene;

    [SerializeField] private LevelsManager _levelsManager;

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
        }
    }

    public void BackToMenu(string scene)
    {
        LevelsManager.Instance.ChangeScene(scene);
    }

    public void TerminateGame()
    {
        LevelsManager.Instance.QuitGame();
    }
}
