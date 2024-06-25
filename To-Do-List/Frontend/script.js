const apiUrl = 'https://your-api-gateway-id.execute-api.your-region.amazonaws.com/Prod';

async function addTask() {
    const taskInput = document.getElementById('taskInput');
    const taskName = taskInput.value;

    const response = await fetch(`${apiUrl}/tasks`, {
        method: 'POST',
        body: JSON.stringify({ task_name: taskName }),
        headers: {
            'Content-Type': 'application/json'
        }
    });

    const result = await response.json();
    loadTasks();
}

async function loadTasks() {
    const response = await fetch(`${apiUrl}/tasks`);
    const tasks = await response.json();
    const taskList = document.getElementById('taskList');
    taskList.innerHTML = '';

    tasks.forEach(task => {
        const li = document.createElement('li');
        li.textContent = task.TaskName;
        li.onclick = () => deleteTask(task.TaskId);
        taskList.appendChild(li);
    });
}

async function deleteTask(taskId) {
    await fetch(`${apiUrl}/tasks`, {
        method: 'DELETE',
        body: JSON.stringify({ task_id: taskId }),
        headers: {
            'Content-Type': 'application/json'
        }
    });

    loadTasks();
}

loadTasks();
