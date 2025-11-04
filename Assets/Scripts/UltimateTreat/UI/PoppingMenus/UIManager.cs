using System.Collections.Generic;
using UnityEngine;

public class UIManager : Singleton<UIManager>
{
    [SerializeField] private GameObject _safeZone;
    [SerializeField] private PauseDialog _pauseOptionsPrefab;
    [SerializeField] private ConfirmationDialog _confirmationDialogPrefab;
    [SerializeField] private ScoreboardDialog _scoreboardPrefab;
    //[SerializeField] private PlayAgainDialog _playAgainPrefab;

    Dictionary<Menus, DialogBase> _dialogInstances = new();

    Stack<DialogBase> _dialogStack = new Stack<DialogBase>();
    Dictionary<Menus, DialogBase> _disabledDialogs = new ();

    private int _topSortingOrder = 0;
    private const int _sortOrderGap = 10;

    public DialogBase ShowDialog(Menus dialogType)
    {
        return PushDialog(dialogType);
    }

    public DialogBase PushDialog(Menus dialogType)
    {
        if (!_dialogInstances.ContainsKey(dialogType))
        {
            DialogBase created = null;
            switch (dialogType)
            {
                case Menus.PauseMenu:
                    created = CreateDialogFromPrefab(_pauseOptionsPrefab);
                    break;
                case Menus.ConfirmationDialog:
                    created = CreateDialogFromPrefab(_confirmationDialogPrefab);
                    break;
                case Menus.Scoreboard:
                    created = CreateDialogFromPrefab(_scoreboardPrefab);
                    break;
                /*case Menus.PlayAgain:
                    created = CreateDialogFromPrefab(_playAgainPrefab);
                    break;*/
            }
            if (created == null)
            {
                Debug.LogError($"Could not created dialog from prefab: {dialogType}");
            }
            else
            {
                _dialogInstances.Add(dialogType, created);
            }
        }
        DialogBase instance = _dialogInstances[dialogType];
        if (_dialogStack.Contains(instance))
        {
            Debug.LogError($"Dialog is already pushed: {dialogType}");
        }
        else
        {
            if (_disabledDialogs.ContainsKey(dialogType))
            {
                _disabledDialogs.Remove(dialogType);
            }
            _dialogStack.Push(instance);
            instance.gameObject.SetActive(true);
            instance.DialogCanvas.overrideSorting = true;
            _topSortingOrder += _sortOrderGap;
            instance.DialogCanvas.sortingOrder = _topSortingOrder;
        }
        return instance;
    }

    private DialogBase CreateDialogFromPrefab(DialogBase dialogPrefab)
    {
        DialogBase created = Instantiate(dialogPrefab , _safeZone.transform);
        created.OnCreation(this);
        return created;
    }

    public void HideDialog(Menus dialogType)
    {
        PopDialog(dialogType);
    }

    private void PopDialog(Menus dialogType)
    {
        if (!_dialogInstances.ContainsKey(dialogType))
        {
            Debug.LogError($"Tried to pop dialog, but dialog was never created {dialogType}");
            return;
        }
        DialogBase instance = _dialogInstances[dialogType];

        if(_dialogStack.TryPeek(out DialogBase topDialogPeek))
        {
            if(topDialogPeek == instance)
            {
                DialogBase topDialog = _dialogStack.Pop();
                topDialog.gameObject.SetActive(false);
                _disabledDialogs.Add(topDialog.MenuType(), topDialog);
                _topSortingOrder -= _sortOrderGap;  
            }
            else
            {
                Debug.LogError($"Tried to pop the dialog type {dialogType} but the top dialog was {topDialogPeek.MenuType()}");
            }
        }
        else
        {
            Debug.LogError($"Failed to peek the top dialog");
        }
    }
}
