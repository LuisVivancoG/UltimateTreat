using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LevelsManager : PersistentSingleton<LevelsManager>
{
    [Header("Loading UI")]
    [SerializeField] private GameObject _loadingUIPrefab;
    [SerializeField] private Image _progressBar;

    protected override void Awake()
    {
        base.Awake();
        //DontDestroyOnLoad(_loadingUIPrefab);

        _loadingUIPrefab.SetActive(false);
    }

    public void ChangeScene(string sceneName)
    {
        StartCoroutine(LoadAsyncScene(sceneName));
    }

    IEnumerator LoadAsyncScene(string scene)
    {
        AsyncOperation loading = SceneManager.LoadSceneAsync(scene);
        _loadingUIPrefab.SetActive(true);

        while (!loading.isDone)
        {
            _progressBar.fillAmount = loading.progress;
            yield return null;
        }
        _loadingUIPrefab.SetActive(false);
    }

    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif

        Application.Quit();
    }
}
