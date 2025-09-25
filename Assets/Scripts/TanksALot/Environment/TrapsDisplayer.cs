using UnityEngine;
using static UnityEngine.Rendering.BoolParameter;

public class TrapsDisplayer : MonoBehaviour
{
    [SerializeField] private Traps _trapType;
    [SerializeField] private GameObject _barrel;
    [SerializeField] private GameObject _mine;

    private void OnValidate()
    {
        UpdateDisplay();
    }

    private void UpdateDisplay()
    {
        switch (_trapType)
        {
            case Traps.None:
                if (_barrel) _barrel.SetActive(false);
                if (_mine) _mine.SetActive(false);
                break;

            case Traps.Barrel:
                if (_barrel) _barrel.SetActive(true);
                if (_mine) _mine.SetActive(false);
                break;

            case Traps.Mine:
                if (_barrel) _barrel.SetActive(false);
                if (_mine) _mine.SetActive(true);
                break;
        }
    }
    public void SetDisplayType(Traps newDisplayType)
    {
        _trapType = newDisplayType;
        UpdateDisplay();
    }
}
