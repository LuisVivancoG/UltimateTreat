using UnityEngine;

public class LevelBoundaries : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        other.TryGetComponent<HealthSystem>(out var component);
        Debug.Log($"Collider in boundaries. Found {component.gameObject.name}");
        if (component != null)
        {
            Debug.Log($"Proceeding to kill {other.gameObject.name}");
            component.Death();
        }
        else
        {
            Debug.Log($"No players found");
            return;
        }
    }
}
