var uploader = new plupload.Uploader({
    browse_button: 'browse', // this can be an id of a DOM element or the DOM element itself
    url: 'upload',
    file_data_name: 'files[]'
});

var scrolled_once = false;

uploader.init();

uploader.bind('FilesAdded', function(up, files) {
    console.log("fired filesadded");
    var html = '';
    plupload.each(files, function(file) {
        name_truncated = file.name;
        if (file.name.length > 24) {
            name_truncated = name_truncated.substring(0, 21) + "...";
        }

        html += '<li id="' + file.id + '"><p title="' + file.name + '">' + name_truncated + '</p> (' + plupload.formatSize(file.size) + ') <b></b></li>';
    });
    document.getElementById('upload-list').innerHTML += html;
    document.getElementById('upload-container').style.display = 'block';

    if(!scrolled_once) {
        $('html,body').animate({scrollTop: $('#upload-container').offset().top - 50 + 'px'});
        scrolled_once = true;
    }

    uploader.start();
});

uploader.bind('UploadProgress', function(up, file) {
    document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
});

uploader.bind('Error', function(up, err) {
    document.getElementById('console').innerHTML += "\nError #" + err.code + ": " + err.message;
});

uploader.bind('FileUploaded', function (up, file, response) {
    file_name = document.getElementById(file.id).getElementsByTagName('p')[0].innerHTML;

    console.log(file_name)

    url = JSON.parse(response.response).files[0].url

    document.getElementById(file.id).getElementsByTagName('p')[0].innerHTML = '<a href="' + url + '" target="_blank">' + file_name + '</a>';


});

$body = $('body');

$body.on('drag dragstart dragend dragover dragenter dragleave drop', function(e) {
    e.preventDefault();
    e.stopPropagation();
})
.on('dragover dragenter', function() {
    $body.addClass('is-dragover');
    document.getElementById('browse').innerHTML = "Drop your file(s)!";
})
.on('dragleave dragend drop', function() {
    $body.removeClass('is-dragover');
    document.getElementById('browse').innerHTML = "Click here or drag your file(s) anywhere to start uploading.";
})
.on('drop', function(e) {
    droppedFiles = e.originalEvent.dataTransfer.files;

    fileArray = [];

    $.each(droppedFiles, function(i, file) {
        fileArray.push(file);
    });

    uploader.addFile(fileArray);
});
