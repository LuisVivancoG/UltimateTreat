using UnityEngine;
using UnityEngine.UI;

public class PlayerDisplay : MonoBehaviour
{
    [SerializeField] private Button _rightButton;
    [SerializeField] private Button _leftButton;

    public Button RightBtn { get { return _rightButton; } set { _rightButton = value; } }
    public Button LeftBtn { get { return _leftButton; } set { _leftButton = value; } }
}
