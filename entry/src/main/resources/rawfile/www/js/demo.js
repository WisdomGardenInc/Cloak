window.document.addEventListener(
  "CloakReady",
  () => {
    displayPluginsInfo();
  },
  { once: true }
);

window.onload = function () {
  document.querySelector("div.demo").innerText = window.location.href + "\n" + window.navigator.userAgent;
  initDB();
};

const onAlert = () => {
  const result = alert("alert content");
  console.log(result);
};

const onConfirm = () => {
  const result = confirm("confirm content");
  console.log(result);
};

// Media Capacity
const takePhoto = async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" } });
    const video = document.createElement("video");
    video.srcObject = stream;
    await video.play();

    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    canvas.getContext("2d").drawImage(video, 0, 0);

    const image = document.createElement("img");
    image.src = canvas.toDataURL("image/jpeg");
    document.getElementById("mediaPreview").innerHTML = "";
    document.getElementById("mediaPreview").appendChild(image);

    stream.getTracks().forEach((track) => track.stop());
  } catch (error) {
    console.error("take photo error:", error);
  }
};

const recordVideo = async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" }, audio: true });
    const mediaRecorder = new MediaRecorder(stream);
    const chunks = [];

    mediaRecorder.ondataavailable = (e) => chunks.push(e.data);
    mediaRecorder.onstop = () => {
      const blob = new Blob(chunks, { type: "video/webm" });
      const video = document.createElement("video");
      video.src = URL.createObjectURL(blob);
      video.controls = true;
      document.getElementById("mediaPreview").innerHTML = "";
      document.getElementById("mediaPreview").appendChild(video);
    };

    mediaRecorder.start();
    setTimeout(() => {
      mediaRecorder.stop();
      stream.getTracks().forEach((track) => track.stop());
    }, 5000); // capture 5 seconds
  } catch (error) {
    console.error("record video error", error);
  }
};

const recordAudio = async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    const mediaRecorder = new MediaRecorder(stream);
    const chunks = [];

    mediaRecorder.ondataavailable = (e) => chunks.push(e.data);
    mediaRecorder.onstop = () => {
      const blob = new Blob(chunks, { type: "audio/webm" });
      const audio = document.createElement("audio");
      audio.src = URL.createObjectURL(blob);
      audio.controls = true;
      document.getElementById("mediaPreview").innerHTML = "";
      document.getElementById("mediaPreview").appendChild(audio);
    };

    mediaRecorder.start();
    setTimeout(() => {
      mediaRecorder.stop();
      stream.getTracks().forEach((track) => track.stop());
    }, 5000); // capture 5 seconds
  } catch (error) {
    console.error("record audio error:", error);
  }
};

const previewFile = (file) => {
  let node = null;
  if (file.type.startsWith("image/")) {
    node = document.createElement("img");
    node.src = URL.createObjectURL(file);
  } else if (file.type.startsWith("video/")) {
    node = document.createElement("video");
    node.src = URL.createObjectURL(file);
    node.controls = true;
  } else if (file.type.startsWith("audio/")) {
    node = document.createElement("audio");
    node.src = URL.createObjectURL(file);
    node.controls = true;
  } else if (file.type.startsWith("application/pdf")) {
    node = document.createElement("embed");
    node.src = URL.createObjectURL(file);
    node.width = "100%";
    node.height = "500px";
  } else {
    node = document.createElement("div");
    node.textContent = `Selected file: ${file.name} (${file.type})`;
  }
  document.getElementById("mediaPreview").innerHTML = "";
  document.getElementById("mediaPreview").appendChild(node);
};

const selectFile = (accept = "") => {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = accept;
  input.multiple = true;
  input.onchange = (e) => {
    previewFile(e.target.files[0]);
  };
  input.click();
};

const takeMedia = (accept = "") => {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = accept;
  input.capture = "user";
  input.onchange = (e) => {
    previewFile(e.target.files[0]);
  };
  input.click();
};

// Geolocation Capacity
let watchId = null;

const getLocation = () => {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        document.getElementById(
          "locationInfo"
        ).textContent = `Latitude: ${position.coords.latitude}, Longitude: ${position.coords.longitude}`;
      },
      (error) => {
        console.error("Get location error:", error);
      },
      {
        enableHighAccuracy: true,
        maximumAge: 0,
        timeout: 5000,
      }
    );
  }
};

const getLocationNative = async () => {
  if (Cloak?.plugins?.Geolocation) {
    const result = await Cloak.plugins.Geolocation.getLocation();
    document.getElementById("locationInfo").textContent = JSON.stringify(result, null, 2);
  }
};

const startWatchLocation = () => {
  if (navigator.geolocation && !watchId) {
    watchId = navigator.geolocation.watchPosition(
      (position) => {
        document.getElementById(
          "locationInfo"
        ).textContent = `Real-time location - Latitude: ${position.coords.latitude}, Longitude: ${position.coords.longitude}`;
      },
      (error) => {
        console.error("Watch location error:", error);
      }
    );
  }
};

const stopWatchLocation = () => {
  if (watchId) {
    navigator.geolocation.clearWatch(watchId);
    watchId = null;
    document.getElementById("locationInfo").textContent = "Location watch stopped";
  }
};

// Scan Qrcode Capacity
let qrCodevideoStream = null;

const startQRScan = async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } });
    qrCodevideoStream = stream;
    const video = document.getElementById("qrVideo");
    video.srcObject = stream;
    video.style.display = "block";
    await video.play();

    // QR code parsing library is needed here to achieve full functionality
    // For demonstration, we only show video preview
    document.getElementById("qrResult").textContent =
      "Camera is on (QR code parsing library needed for full functionality)";
  } catch (error) {
    console.error("QR scan error:", error);
  }
};

const stopQRScan = async () => {
  if (qrCodevideoStream) {
    qrCodevideoStream.getTracks().forEach((track) => track.stop());
    qrCodevideoStream = null;
    const video = document.getElementById("qrVideo");
    video.style.display = "none";
    document.getElementById("qrResult").textContent = "QR scan stopped";
  }
};

// Vibration function
const vibrate = () => {
  if (navigator.vibrate) {
    navigator.vibrate([200, 100, 200]); // Vibration pattern: 200ms on - 100ms off - 200ms on
  }
};

// IndexedDB operations
// IndexedDB initialization
let db;
const initDB = () => {
  const request = indexedDB.open("NotesDB", 1);

  request.onerror = (event) => {
    console.error("Database error:", event.target.error);
  };

  request.onupgradeneeded = (event) => {
    db = event.target.result;
    if (!db.objectStoreNames.contains("notes")) {
      db.createObjectStore("notes", { keyPath: "id", autoIncrement: true });
    }
  };

  request.onsuccess = (event) => {
    db = event.target.result;
    displayNotes();
  };
};

const addNote = () => {
  const noteInput = document.getElementById("noteInput");
  const note = {
    content: noteInput.value,
    timestamp: new Date().toISOString(),
  };

  const transaction = db.transaction(["notes"], "readwrite");
  const store = transaction.objectStore("notes");
  store.add(note);

  transaction.oncomplete = () => {
    noteInput.value = "";
    displayNotes();
  };
};

const displayNotes = () => {
  const transaction = db.transaction(["notes"], "readonly");
  const store = transaction.objectStore("notes");
  const request = store.getAll();

  request.onsuccess = () => {
    const notes = request.result;
    const notesList = document.getElementById("notesList");
    notesList.innerHTML = "";

    notes.forEach((note) => {
      const div = document.createElement("div");
      div.className = "note-item";
      div.innerHTML = `
                <span>${note.content}</span>
                <button onclick="deleteNote(${note.id})">Delete</button>
            `;
      notesList.appendChild(div);
    });
  };
};

const deleteNote = (id) => {
  const transaction = db.transaction(["notes"], "readwrite");
  const store = transaction.objectStore("notes");
  store.delete(id);

  transaction.oncomplete = () => {
    displayNotes();
  };
};

const displayPluginsInfo = () => {
  const pluginsInfoDiv = document.getElementById("pluginsInfo");
  pluginsInfoDiv.innerHTML = "";

  if (window.Cloak && window.Cloak.plugins) {
    const plugins = window.Cloak.plugins;
    for (const pluginName in plugins) {
      if (plugins.hasOwnProperty(pluginName)) {
        const plugin = plugins[pluginName];
        const metadata = plugin.getMetadata();
        const pluginInfo = document.createElement("div");
        pluginInfo.className = "plugin-item";
        pluginInfo.innerHTML = `
                    <h3>📦 ${metadata.name}</h3>
                    <p>Version: ${metadata.version}</p>
                    <p>Methods: ${metadata.methods.join(", ")}</p>
                    <p>${metadata.description}</p>
                `;
        pluginsInfoDiv.appendChild(pluginInfo);
      }
    }
  } else {
    pluginsInfoDiv.textContent = "No plugins installed.";
  }
};

// permission
const queryPermissions = async (permissions) => {
  const result = await Cloak.plugins.Permission.query(permissions);
  alert(JSON.stringify(result, null, 2));
};

const requestPermissions = async (permissions) => {
  const result = await Cloak.plugins.Permission.request(permissions);
  alert(JSON.stringify(result, null, 2));
};

const postMessageObject = () => {
  Cloak.plugins.Device.sendMessage({ aaa: "test" });
};

const onOpenUrl = async (url) => {
  const browser = Cloak.plugins.InAppBrowser.create(url, "_blank", { clearcache: true, footer: false });

  browser.open();

  browser.addEventListener('loadstart', function (event) {
    alert("addEventListener loadstart: " + event.url);
  });

  browser.on("loadstart").subscribe(({ url }) => {
    alert("on loadstart: " + url);
  });


  browser.on("loadstop").subscribe(({ url }) => {
    browser.executeScript({ code: "document.querySelector('.core-card .card-title').innerText = '和 Wisdom Garden 一起开启 OpenHarmony 之旅吧！';document.querySelector('.core-card .card-title').style.fontSize = '2rem';document.querySelector('.core-card .card-title').style.color = 'red';" });
    browser.insertCSS({ code: ".card-summary {color: purple !important;}" });
    alert("on loadstop: " + url);
  });

  browser.on("exit").subscribe(() => {
    alert("closed");
  });
};



const callback = (event) => {
  alert("addEventListener alert: " + event.data);
}
let handlerId = null;

const addEvent = () => {
  handlerId = Cloak.plugins.Device.addEventListener("test", callback);
}

const removeEvent = () => {
  Cloak.plugins.Device.removeEventListener("test", handlerId);
}

const removeAllevent = () => {
  Cloak.plugins.Device.clearAllEvents();
}

const triggerEvent = () => {
  Cloak.plugins.Device.sendTestEvent();
}