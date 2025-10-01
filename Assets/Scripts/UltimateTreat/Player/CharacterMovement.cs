using UnityEngine;

public class CharacterMovement : MonoBehaviour
{
    [Header("Component references")]
    [SerializeField] private Rigidbody _rb;

    [Header("Parameters settings")]
    [SerializeField] private float _movementSpeed = 3f;
    [SerializeField] private float _turnSpeed = 0.1f;

    //Stored values
    private Vector3 _movementDirection;
    private Quaternion _currentOrientation;
    private Vector3 _lookAtDirection;

    private void Start()
    {
        _currentOrientation = Quaternion.identity;
        _lookAtDirection = Vector3.forward;
    }
    public void UpdateMovementData(Vector3 newMovementDirection)
    {
        _movementDirection = newMovementDirection;
    }

    public void UpdateLookAtData(Vector3 newLookDirection)
    {
        if (newLookDirection.sqrMagnitude > 0.01f)
        {
            _lookAtDirection = newLookDirection;
        }
    }

    void FixedUpdate()
    {
        MoveThePlayer();
        TurnThePlayer();

        //Debug.Log($"Current move direction = {_movementDirection}");
    }

    void MoveThePlayer()
    {
        Vector3 movement = WorldDirection(_movementDirection);
        //_rb.MovePosition(transform.position + movement);
        _rb.AddForce(movement * _movementSpeed * Time.deltaTime);
    }

    void TurnThePlayer()
    {
        Quaternion targetRotation = Quaternion.LookRotation(_lookAtDirection);

        Quaternion rotation = Quaternion.Slerp(_currentOrientation, targetRotation, _turnSpeed);
        _rb.MoveRotation(rotation);
        _currentOrientation = rotation;
    }
    Vector3 WorldDirection(Vector3 movementDirection)
    {
        var worldForward = Vector3.forward;
        var worldRight = Vector3.right;

        worldForward.y = 0f;
        worldRight.y = 0f;

        return worldForward * movementDirection.z + worldRight * movementDirection.x;
    }
}
