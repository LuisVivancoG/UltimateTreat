using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerStateMachine : MonoBehaviour
{
    CharacterController _cC;
    Animator _animator;
    PlayerInputMultiplayer _playerInput;

    Vector2 _currentMovementInput;
    Vector2 _currentLookInput;
    Vector3 _currentMovement;
    //Vector3 _appliedMovement;

    bool _isMovementPressed;
    bool _isFirePressed;
    //bool _
}
