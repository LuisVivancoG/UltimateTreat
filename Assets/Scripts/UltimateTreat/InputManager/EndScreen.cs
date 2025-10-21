using UnityEngine;
using UnityEngine.EventSystems;

public class EndScreen : MonoBehaviour
{
    [Header("GameplayScene")]
    [SerializeField] private string _nextScene;

    //[Header("EventSystem")]
    //private EventSystem _system;

    private void Awake()
    {
        //_system = FindAnyObjectByType<EventSystem>();
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
