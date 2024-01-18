from django.views.generic import ListView, DetailView, TemplateView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy
from django.db.models import Q
from .models import Post


class BlogListView(ListView):
    model = Post
    template_name = "posts.html"


class BlogDetailView(DetailView):
    model = Post
    template_name = "post_detail.html"


class BlogHome(TemplateView):
    model = Post
    template_name = "home.html"


class BlogCreateView(LoginRequiredMixin, CreateView):
    model = Post
    template_name = "post_new.html"
    fields = ["title", "author", "body", "cover"]


class BlogUpdateView(LoginRequiredMixin, UpdateView):
    model = Post
    template_name = "post_edit.html"
    fields = ["title", "body", "cover"]


class BlogDeleteView(LoginRequiredMixin, DeleteView):
    model = Post
    template_name = "post_delete.html"
    success_url = reverse_lazy("home")


class BlogSearch(ListView):
    model = Post
    template_name = 'posts.html'

    def get_context_data(self, *, object_list=None, **kwargs):
        print('get_context_data')
        context = super().get_context_data(**kwargs)
        q = self.request.GET.get('q')
        context['q']=q
        return context

    def get_queryset(self):
        print('get_queryset')
        query = self.request.GET.get('q')
        object_list = Post.objects.filter(
            Q(title__icontains=query) | Q(body__icontains=query) | Q(author__username__icontains=query) | Q(author__email__icontains=query) | Q(author__last_name__icontains=query) | Q(author__first_name__icontains=query)
        )
        return object_list
