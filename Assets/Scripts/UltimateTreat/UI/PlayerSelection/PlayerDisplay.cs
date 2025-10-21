using UnityEngine;

public class PlayerDisplay : MonoBehaviour
{
    [SerializeField] private RectTransform _gOTransform;
    //[SerializeField] private GameObject _inputGO;
    public RectTransform GOTransform { get { return _gOTransform; } }
    //public GameObject InputGO { get { return _inputGO; } }

    private void Start()
    {
        var component = FindAnyObjectByType<SystemInputsManager>().PlayersGrp;
        gameObject.transform.SetParent(component.transform);
    }
}
